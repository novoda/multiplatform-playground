import * as React from "react"
import { observer } from "mobx-react-lite"
import { PlaygroundTabScreenProps } from "../navigators"
import { FlatList, Image, ScrollView, View } from "react-native"
import { Button, Text } from "../components"
import { colors, spacing } from "../theme"
import { useStores } from "../models"
import { Content, ErrorState } from "../models/PhotosScreenStore"
import { Card } from "react-native-paper"
import { Photo } from "../models/Photo"

interface PlaygroundScreenProps extends PlaygroundTabScreenProps<"Photos"> {
}

export const PhotosScreen: React.FC<PlaygroundScreenProps> = observer(() => {
  const { photosScreenStore: store } = useStores()

  React.useEffect(() => {
    store.load()
  }, [store])

  const { fullScreenLoading, error, content } = store.uiState
  let renderedContent
  if (fullScreenLoading) {
    renderedContent = <LoadingComponent />
  } else if (error) {
    renderedContent = <ErrorComponent
      error={error}
      onResetClicked={store.load} />
  } else if (content) {
    renderedContent = <ContentComponent
      content={content}
      isLoading={store.uiState.isLoading}
      loadNext={store.nextPage}
    />
  } else {
    throw new Error(`UiState type is not handled ${JSON.stringify(store.uiState)}`)
  }
  return (
    <View style={{
      backgroundColor: colors.background,
      flex: 1,
    }}>
      {renderedContent}
    </View>
  )
})

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
          borderRadius: 16,
        }
      }
      source={{
        uri: photo.urls.regular,
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
    ListFooterComponent={
      props.isLoading ? <LoadingComponent /> : null
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