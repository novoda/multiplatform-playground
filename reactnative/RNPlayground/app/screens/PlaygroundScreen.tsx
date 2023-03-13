import * as React from "react"
import { observer } from "mobx-react-lite"
import { BaseScreenProps } from "../navigators"
import { Image, ImageStyle, TextStyle, View, ViewStyle } from "react-native"
import { Text, Screen, Button } from "../components"
import { isRTL } from "../i18n"
import { colors, spacing } from "../theme"
import { useSafeAreaInsetsStyle } from "../utils/useSafeAreaInsetsStyle"
import { useFocusEffect, useIsFocused } from "@react-navigation/core"
import { action, makeAutoObservable, observable, when } from "mobx"
import { useStores } from "../models"
import { EdgeInsets } from "react-native-safe-area-context"


interface PlaygroundScreenProps extends BaseScreenProps<"Playground"> {
}

export const PlaygroundScreen: React.FC<PlaygroundScreenProps> = observer((props) => {
  const $bottomContainerInsets = useSafeAreaInsetsStyle(["bottom"])
  const { playgroundStore } = useStores()

  useFocusEffect(
    React.useCallback(() => {
      playgroundStore.startCounter()
      return () => playgroundStore.stopCounter()
    }, [playgroundStore])
  )

  return <View style={$container}>
    {
      StateComponent(
        $bottomContainerInsets,
        playgroundStore.uiState,
        () => playgroundStore.resetCounter()
      )
    }
  </View>
})

function StateComponent(insets, uiState, onResetClicked) {
  const { loading, error, content } = uiState
  if (loading) {
    return LoadingComponent(insets)
  } else if (error) {
    return ErrorComponent(insets, error, onResetClicked)
  } else if (content) {
    return ContentComponent(insets, content, onResetClicked)
  }
  throw new Error(`UiState type is not handled ${JSON.stringify(uiState)}`)
}

function ContentComponent(insets, content, onResetClicked) {
  return <View>
    <View style={$topContainer}>
      <Text
        testID="welcome-heading"
        style={$welcomeHeading}
        tx="playgroundScreen.readyForLaunch"
        preset="heading"
      />
      <Text tx="playgroundScreen.postscript" preset="subheading" />
    </View>

    <View style={[$bottomContainer, insets]}>
      <Text tx="playgroundScreen.exciting" size="md" />
      <Text text={`Value is: ${content.number}`} size="md" />
      <Button text="Reset" onPress={onResetClicked} />
    </View>
  </View>
}

function ErrorComponent(insets, error, onResetClicked) {
  return <View style={[insets]}>
    <Text text={`ERROR: ${error.message}`} size="md" />
    <Button text="Refresh" onPress={onResetClicked} />
  </View>
}

function LoadingComponent(insets) {
  return <View style={[insets, { justifyContent: "space-around", flexGrow: 1 }]}>
    <Text text={`LOADING`} size="md" style={{ textAlign: "center" }} />
  </View>
}

const $container: ViewStyle = {
  flex: 1,
  backgroundColor: colors.background,
}

const $topContainer: ViewStyle = {
  flexShrink: 1,
  flexGrow: 1,
  flexBasis: "57%",
  justifyContent: "center",
  paddingHorizontal: spacing.large,
}

const $bottomContainer: ViewStyle = {
  flexShrink: 1,
  flexGrow: 0,
  flexBasis: "43%",
  backgroundColor: colors.palette.neutral100,
  borderTopLeftRadius: 16,
  borderTopRightRadius: 16,
  paddingHorizontal: spacing.large,
  justifyContent: "space-around",
}

const $welcomeHeading: TextStyle = {
  marginBottom: spacing.medium,
}

