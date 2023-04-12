import * as React from "react"
import { useAppDispatch, useAppSelector } from "../../hooks"
import { PlaygroundTabScreenProps } from "../../navigators"
import { FlatList, Image, ScrollView, View } from "react-native"
import { spacing, useAppTheme } from "../../theme"
import { ActivityIndicator, Button, Card, Text } from "react-native-paper"
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

type ItemProps = {
  photo: Photo,
  index: number
}
const Item = ({ photo, index }: ItemProps) => {
  const colors = useAppTheme().colors
  return <Card
    style={
      {
        backgroundColor: photo.color,
        marginVertical: spacing.extraSmall,
        marginHorizontal: spacing.medium,
        overflow: "hidden",
      }
    }
    elevation={0}
    contentStyle={
      {
        height: 300,
        borderRadius: 16,
      }
    }
  >
    <Image
      style={
        {
          width: "100%",
          height: "100%",
        }
      }
      source={{
        uri: photo.urls.regular,
      }}
    />
    <View
      style={{
        width: "100%",
        position: "absolute",
        bottom: 0,
        backgroundColor: colors.backdrop,
        padding: spacing.small,
      }}>
      <Text
        style={{
          color: colors.onPrimary,
          opacity: 0.8,
        }}
        variant={"bodyMedium"}>{index + 1}</Text>
      {photo.description
        ?
        < Text
          style={{
            color: colors.onPrimary,
            opacity: 0.8,
          }}
          variant={"bodyMedium"}>{photo.description}</Text>
        : null
      }
    </View>
  </Card>
}

const ContentComponent = (props: ContentComponentProps) => (
  <FlatList
    testID={"photos_content"}
    data={props.content.photos}
    renderItem={({ item, index }) => <Item photo={item} index={index} />}
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
  <View
    style={{
      flex: 1,
    }}>
    <ScrollView
      contentContainerStyle={{
        paddingHorizontal: 16,
        paddingVertical: 16,
        flex: 1,
        justifyContent: "space-between",
      }}
    >
      <Text variant="bodyLarge">ERROR: ${error.message}</Text>
    </ScrollView>
    <Button style={{ margin: 16 }} mode={"contained"} onPress={onResetClicked}>Refresh</Button>
  </View>
)

const LoadingComponent = () => (
  <View style={[{ justifyContent: "space-around", flexGrow: 1 }]}>
    <ActivityIndicator animating={true} size={"large"} testID={"loading_indicator"} />
  </View>
)