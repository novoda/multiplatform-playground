import * as React from "react"
import { Alert, FlatList, Platform, ToastAndroid } from "react-native"
import { Text } from "../../components"
import { colors, spacing } from "../../theme"
import { Card } from "react-native-paper"
import { PlaygroundTabScreenProps } from "../../navigators"

export interface PlaygroundScreenProps extends PlaygroundTabScreenProps<"Playground"> {
}

export const PlaygroundScreen: React.FC<PlaygroundScreenProps> = ({ navigation }) => {
  const items: PlaygroundCardProps[] = [
    photosItem(navigation),
    clickMeItem,
    {
      title: "I do nothing",
      color: "forestgreen",
      onPress: () => {
      },
    },
  ]

  return <FlatList
    style={{
      backgroundColor: colors.background,
      flex: 1,
    }}
    data={items}
    renderItem={({ item }) =>
      <PlaygroundCard
        title={item.title}
        color={item.color}
        onPress={item.onPress}
      />
    }
  >
  </FlatList>
}

const photosItem = (navigation) => ({
  title: "Photos",
  onPress: () => navigation.navigate("Photos"),
  color: "darksalmon",
})

const clickMeItem = {
  title: "Click me",
  color: colors.palette.accent300,
  onPress: () => {
    if (Platform.OS == "android") {
      ToastAndroid.show("You're Android, here's a toast to you", ToastAndroid.SHORT)
    } else {
      Alert.alert(
        "Alert",
        "You're not on Android",
        [{
          text: "Duh",
          style: "cancel",
        }],
      )
    }
  },
}

type PlaygroundCardProps = {
  title: string,
  onPress: () => void,
  color: string
}

function PlaygroundCard(props: PlaygroundCardProps) {
  return (
    <Card
      style={{
        backgroundColor: props.color,
        marginVertical: spacing.extraSmall,
        marginHorizontal: spacing.medium,
      }}
      theme={{
        mode: "adaptive",
      }}
      onPress={props.onPress}
    >
      <Text
        text={props.title}
        style={{
          padding: spacing.medium,
        }}
        preset="bold"
        size="lg"
      />
    </Card>
  )
}
