import React, { FC } from "react"
import { BaseScreenProps } from "../../navigators"
import { ViewStyle } from "react-native"
import { Screen, Text } from "../../components"
import { colors } from "../../theme"

export const AboutScreen: FC<BaseScreenProps<"About">> = () => {
  return (
    < Screen
      preset="fixed"
      safeAreaEdges={["top"]}
      contentContainerStyle={container}
    >
      <Text>This is top text, right under the status bar.</Text>
      <Text>This is bottom text. right above the bottom tabs.</Text>
    </Screen>
  )
}

const container: ViewStyle = {
  flex: 1,
  backgroundColor: colors.background,
  justifyContent: "space-between",
  alignItems: "center",
}
