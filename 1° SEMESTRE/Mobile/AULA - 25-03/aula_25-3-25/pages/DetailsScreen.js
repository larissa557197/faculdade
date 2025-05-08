// DetailsScreen.js
import React, { useState } from 'react';
import { View, Text, Button } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function DetailsScreen({ navigation }) {
  const [phoneNumber, setPhoneNumber] = useState('123-456-7890');

  return (
    <SafeAreaView style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <Text>Name: John Doe</Text>
      <Text>Phone Number: {phoneNumber}</Text>
      <Button
        title="Edit"
        onPress={() => navigation.navigate('Edit', { phoneNumber, setPhoneNumber })}
      />
    </SafeAreaView>
  );
}