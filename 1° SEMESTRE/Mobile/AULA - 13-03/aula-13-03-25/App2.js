import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';

function WelcomePage() {
  const [name, setName] = useState(''); // Estado para o nome
  const [isSubmitted, setIsSubmitted] = useState(false); // Estado para saber se o nome foi enviado

  // Função para lidar com a mudança no campo de texto
  const handleNameChange = (text) => {
    setName(text);
  };

  // Função para lidar com o envio do nome
  const handleSubmit = () => {
    if (isSubmitted) {
      // Se o nome foi enviado, resetamos o nome
      setName('');
      setIsSubmitted(false);
    } else {
      // Se o nome não foi enviado, atualizamos o estado para mostrar o olá
      setIsSubmitted(true);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Bem-vindo à Página!</Text>
      {!isSubmitted ? (
        <>
          <Text>Qual é o seu nome?</Text>
          <TextInput
            style={styles.input}
            placeholder="Digite seu nome"
            value={name}
            onChangeText={handleNameChange} // Atualiza o nome à medida que o usuário digita
          />
        </>
      ) : (
        <Text style={styles.greeting}>Oi, {name}!</Text>
      )}
      <Button
        title={isSubmitted ? 'Resetar' : 'Enviar'}
        onPress={handleSubmit} // Ao pressionar o botão, chamamos a função handleSubmit
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
  },
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    width: '80%',
    marginBottom: 20,
    paddingLeft: 10,
  },
  greeting: {
    fontSize: 24,
    marginBottom: 20,
  },
});

export default WelcomePage;

