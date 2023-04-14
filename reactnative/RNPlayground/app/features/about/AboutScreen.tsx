import React, { FC } from "react"
import { BaseScreenProps } from "../../navigators"
import { ViewStyle } from "react-native"
import { Text } from "react-native-paper"
import { Screen } from "../../components"

export const AboutScreen: FC<BaseScreenProps<"About">> = () => {
  return (
    < Screen
      preset="fixed"
      safeAreaEdges={["top"]}
      contentContainerStyle={container}
    >
      <Text variant={'displayMedium'}>This is top text, right under the status bar.</Text>
      <Text>This is bottom text. right above the bottom tabs.</Text>
    </Screen>
  )
}

const container: ViewStyle = {
  flex: 1,
  justifyContent: "space-between",
  alignItems: "center",
}
