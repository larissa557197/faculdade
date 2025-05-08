import { StyleSheet, Image, View } from 'react-native';
 import {React, useState, useEffect }from 'react';
import { Button, Text } from 'react-native-web';

export default function App() {
  [counter, setCounter] = useState(0);
  useEffect(() => {
     timer = setTimeout(() => {
        
        setCounter(counter + 1);
      }, 1000);
    return () => clearTimeout(timer);
  }, [counter]);
  
  
  const imagem = 
  'https://www.fiap.com.br/wp-content/themes/fiap2016/images/sharing/fiap.png'
  return (
    <View style={styles.container}>
      <Image style={styles.imgcover}
       source={{uri: imagem }} />
       <Text>Nosso contador está em {counter}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    // Add any container styles 
    // if needed
    flex: 1,
    alignItems: 'center',
    justifyContent: 'top',
  },
  imgcover: {
    marginTop: 50,
    width: '100px',
    height: '100px', // Uncommented 
    // and added height
    resizeMode: 'cover' // Corrected 
    // property name
  },
  
});