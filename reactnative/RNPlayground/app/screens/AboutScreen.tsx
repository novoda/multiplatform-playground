import React, { FC } from "react"
import { observer } from "mobx-react-lite"
import { BaseScreenProps } from "../navigators"
import { ViewStyle } from "react-native"
import {
  Text, Screen
} from "../components"
import { colors } from "../theme"

export const AboutScreen: FC<BaseScreenProps<"About">> = observer(function AboutScreen() {
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
})

const container: ViewStyle = {
  flex: 1,
  backgroundColor: colors.background,
  justifyContent: 'space-between',
  alignItems: 'center',
}
