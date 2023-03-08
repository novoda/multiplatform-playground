import React, { FC } from "react"
import { observer } from "mobx-react-lite"
import { StackScreenProps } from "@react-navigation/stack"
import { AppStackScreenProps } from "../navigators"
import { Image, ImageStyle, TextStyle, View, ViewStyle } from "react-native"
import {
  Text, Screen
} from "../components"
import { isRTL } from "../i18n"
import { colors, spacing } from "../theme"
import { useSafeAreaInsetsStyle } from "../utils/useSafeAreaInsetsStyle"

export const AboutScreen: FC<StackScreenProps<AppStackScreenProps, "About">> = observer(function AboutScreen() {
    const $bottomContainerInsets = useSafeAreaInsetsStyle(["bottom"])

    return (
      <View style={$container}>
        <View style={$topContainer}>
          <Text
            testID="welcome-heading"
            style={$welcomeHeading}
            tx="aboutScreen.readyForLaunch"
            preset="heading"
          />
          <Text tx="aboutScreen.postscript" preset="subheading" />
        </View>

        <View style={[$bottomContainer, $bottomContainerInsets]}>
          <Text tx="aboutScreen.exciting" size="md" />
        </View>
      </View>
    )
})

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
const $welcomeLogo: ImageStyle = {
  height: 88,
  width: "100%",
  marginBottom: spacing.huge,
}

const $welcomeFace: ImageStyle = {
  height: 169,
  width: 269,
  position: "absolute",
  bottom: -47,
  right: -80,
  transform: [{ scaleX: isRTL ? -1 : 1 }],
}

const $welcomeHeading: TextStyle = {
  marginBottom: spacing.medium,
}
