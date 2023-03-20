import * as React from "react"
import { observer } from "mobx-react-lite"
import { BaseScreenProps } from "../navigators"
import { FlatList, View, Image, ImageBackground, ScrollView } from "react-native"
import { Text, Button } from "../components"
import { colors, spacing } from "../theme"
import { useStores } from "../models"
import { Content, ErrorState, PlaygroundStore, PlaygroundUiState } from "../models/PlaygroundStore"
import { Card, Appbar } from "react-native-paper"
import { Photo, PhotoSnapshotOut } from "../models/Photo"

interface PlaygroundScreenProps extends BaseScreenProps<"Playground"> {
  playgroundStore: PlaygroundStore
}

export const PlaygroundScreen: React.FC<PlaygroundScreenProps> = observer(() => {
  const { playgroundStore } = useStores()

  React.useEffect(
    () => { playgroundStore.load() }, [playgroundStore]
  )
  return (
    <View style={{
      backgroundColor: colors.background,
      flex: 1,
    }}>
      <Header />
      {
        StateComponent(
          playgroundStore.uiState,
          playgroundStore.load,
          playgroundStore.nextPage
        )
      }

    </View>
  )
})

const Header = () => (
  <Appbar.Header
    style={{
      backgroundColor: colors.palette.accent100,
    }}
    elevated={true}
    mode='medium'
  >
    <Appbar.Content title={<HeaderTitle />} />
  </Appbar.Header>
)

const HeaderTitle = () => (
  <View>
    <Text
      testID="welcome-heading"
      tx="playgroundScreen.readyForLaunch"
      preset="heading"
    />
  </View>
)

function StateComponent(
  uiState: PlaygroundUiState,
  onResetClicked: () => {},
  loadNext: () => {}
) {
  const { fullScreenLoading, error, content } = uiState

  if (fullScreenLoading) {
    return <LoadingComponent />
  } else if (error) {
    return <ErrorComponent
      error={error}
      onResetClicked={onResetClicked} />
  } else if (content) {
    return <ContentComponent
      content={content}
      isLoading={uiState.isLoading}
      loadNext={loadNext}
    />
  }
  throw new Error(`UiState type is not handled ${JSON.stringify(uiState)}`)
}

type ContentComponentProps = {
  content: Content
  isLoading: boolean
  loadNext: () => {}
}

type ItemProps = { photo: Photo }
const Item = ({ photo }: ItemProps) => {
  return <Card
    style={
      {
        backgroundColor: photo.color,
        marginVertical: spacing.extraSmall,
        marginHorizontal: spacing.medium,
      }
    }
    elevation={0}
  >
    <Image
      style={
        {
          width: null,
          flex: 1,
          height: 300,
          borderRadius: 16
        }
      }
      source={{
        uri: photo.urls.regular
      }}
    />
  </Card>
}

const ContentComponent = (props: ContentComponentProps) => (
  <FlatList
    style={{
      backgroundColor: colors.palette.neutral100,
    }}
    data={props.content.photos}
    renderItem={({ item }) => <Item photo={item} />}
    keyExtractor={item => item.localId}
    onEndReachedThreshold={0.1}
    onEndReached={props.loadNext}
    ListFooterComponent= {
      props.isLoading ? <LoadingComponent/> : null
    }
    
  />
)

type ErrorComponentProps = {
  error: ErrorState,
  onResetClicked: () => {}
}

const ErrorComponent = ({ error, onResetClicked }: ErrorComponentProps) => (
  <ScrollView>
    <Text text={`ERROR: ${error.message}`} size="md" />
    <Button text="Refresh" onPress={onResetClicked} />
  </ScrollView>
)

const LoadingComponent = () => (
  <View style={[{ justifyContent: "space-around", flexGrow: 1 }]}>
    <Text text={`LOADING`} size="md" style={{ textAlign: "center" }} />
  </View>
)