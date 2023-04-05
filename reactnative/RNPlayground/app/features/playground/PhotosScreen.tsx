import * as React from "react"
import { useAppDispatch, useAppSelector } from "../../hooks"
import { PlaygroundTabScreenProps } from "../../navigators"
import { FlatList, Image, ScrollView, View } from "react-native"
import { Button, Text } from "../../components"
import { spacing } from "../../theme"
import { Card } from "react-native-paper"
import { Photo } from "./Photo"
import { clear, fullScreenLoading, load, photosState, ReduxContent, ReduxError } from "./photoSlice"

interface PhotosScreenProps extends PlaygroundTabScreenProps<"Photos"> {
}

export const PhotosScreen: React.FC<PhotosScreenProps> = () => {
  const state = useAppSelector(photosState)
  const dispatch = useAppDispatch()
  React.useEffect(() => {
    dispatch(clear())
    dispatch(load())
  }, [])

  const { error, content } = state
  let renderedContent
  if (fullScreenLoading(state)) {
    renderedContent = <LoadingComponent />
  } else if (error) {
    renderedContent = <ErrorComponent
      error={error}
      onResetClicked={() => dispatch(load())} />
  } else if (content) {
    renderedContent = <ContentComponent
      content={content}
      isLoading={state.isLoading}
      loadNext={() => dispatch(load())}
    />
  } else {
    throw new Error(`UiState type is not handled ${JSON.stringify(state)}`)
  }
  return (
    <View
      style={{
        flex: 1,
      }}
    >
      {renderedContent}
    </View>
  )
}

type ContentComponentProps = {
  content: ReduxContent
  isLoading: boolean
  loadNext: () => void
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
  error: ReduxError,
  onResetClicked: () => void
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