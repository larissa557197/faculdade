import React, { useState, useEffect } from 'react';
import { StyleSheet, Text, View } from 'react-native';

// Função do componente Timer
function Timer() {
  // Declaração do estado 'count' com valor inicial 0
  const [count, setCount] = useState(0);

  // useEffect é usado para executar efeitos colaterais
  useEffect(() => {
    // Define um temporizador que incrementa 'count' a cada segundo
    const timer = setTimeout(() => {
      setCount((count) => count + 1);
    }, 1000);

    // Limpa o temporizador quando o componente é desmontado ou 'count' é atualizado
    return () => clearTimeout(timer);
  }, [count]); // Dependência do efeito, executa quando 'count' muda

  // Renderiza a interface do usuário
  return (
    <View style={styles.container}>
      <Text style={styles.text}>I've rendered {count} times!</Text>
    </View>
  );
}

// Estilos para o componente
const styles = StyleSheet.create({
  container: {
    flex: 1, // O componente ocupa todo o espaço disponível
    justifyContent: 'center', // Centraliza o conteúdo verticalmente
    alignItems: 'center', // Centraliza o conteúdo horizontalmente
  },
  text: {
    fontSize: 20, // Define o tamanho da fonte do texto
  },
});

export default Timer; // Exporta o componente Timer como padrão