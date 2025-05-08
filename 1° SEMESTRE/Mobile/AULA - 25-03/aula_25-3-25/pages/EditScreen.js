// EditScreen.js
import React, { useState } from 'react';
import { View, TextInput, Button } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function EditScreen({ route, navigation }) {
  const { phoneNumber, setPhoneNumber } = route.params;
  const [newPhoneNumber, setNewPhoneNumber] = useState(phoneNumber);

  return (
    <SafeAreaView style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <TextInput
        style={{ height: 40, borderColor: 'gray', borderWidth: 1, marginBottom: 20, width: '80%', paddingHorizontal: 10 }}
        value={newPhoneNumber}
        onChangeText={setNewPhoneNumber}
      />
      <Button
        title="Save"
        onPress={() => {
          setPhoneNumber(newPhoneNumber);
          navigation.goBack();
        }}
      />
    </SafeAreaView>
  );
}