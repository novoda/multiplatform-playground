import * as React from "react"
import { observer } from "mobx-react-lite"
import { View } from "react-native"
import { Text } from "../components"
import { colors, spacing } from "../theme"
import { Card } from "react-native-paper"
import { PlaygroundTabScreenProps } from "../navigators/PlaygroundNavigator"

export interface PlaygroundScreenProps extends PlaygroundTabScreenProps<"Playground"> { }

export const PlaygroundScreen: React.FC<PlaygroundScreenProps> = observer(({ navigation }) => {
  return <View style={{
    backgroundColor: colors.background,
    flex: 1,
  }}>
    <Card
      style={{
        backgroundColor: colors.palette.accent200,
        marginVertical: spacing.extraSmall,
        marginHorizontal: spacing.medium,
        padding: spacing.medium
      }}
      onPress={() => { navigation.navigate("Photos") }}
    >
      <Text tx='playgroundScreen.photos' preset="bold" size="lg" />
    </Card>

  </View>
})
