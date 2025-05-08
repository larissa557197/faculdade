import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, View, Button } from 'react-native';

// Componente principal do aplicativo
export default function App() {
  return (
    <View style={styles.container}>
<<<<<<< HEAD
=======
      {/* Renderiza o componente Classe */}
>>>>>>> origin/main
      <Classe name="User" />
    </View>
  );
}

// Estilos para o componente principal
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});

<<<<<<< HEAD
const Classe = (props) => {
    const [titleText, setTitleText] = React.useState('Ninguem pressionou o botao');

    const onPressButton = (name) => {
        setTitleText(`Botao pressionado por ${name}`);
    };

=======
// Componente de classe que estende React.PureComponent
class Classe extends React.PureComponent {
  // Estado inicial do componente
  state = {
    titleText: 'Ninguem apertou o botao'
  }

  // Função chamada quando o botão é pressionado
  onPressButton = (name) => {
    const now = new Date();
    const timeString = `${now.getHours()}:${now.getMinutes()}:${now.getSeconds()}:${now.getMilliseconds()}`;
    this.setState({ titleText: `Botao pressionado por ${name} as ${timeString}` });
  }

  // Renderiza o componente
  render() {
>>>>>>> origin/main
    return (
      <View>
        {/* Exibe o texto do estado */}
        <Text>
<<<<<<< HEAD
        {titleText}
=======
          {this.state.titleText}
>>>>>>> origin/main
        </Text>
        {/* Botão que chama a função onPressButton ao ser pressionado */}
        <Button title='Stop capturing'
<<<<<<< HEAD
        onPress={() => onPressButton(props.name)}
        color='#FF0000'></Button>
=======
          onPress={() => this.onPressButton(this.props.name)}
          color='#FF0000'>
        </Button>
>>>>>>> origin/main
      </View>
    );
}