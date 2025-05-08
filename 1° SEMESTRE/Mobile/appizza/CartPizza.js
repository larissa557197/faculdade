import React from 'react';
import { View, Text, Image, Button, StyleSheet } from 'react-native';


export default CartPizza = ({cart, onClearCart, isPortrait, selectedPizza, onCloseModal}) => {
    const calculaTotal = () => {
        return cart.reduce(
            (acc, pizza) => acc + pizza.price, 0)
            .toFixed(2);
    }
    return (
        <View style={isPortrait ? styles.cartContainerPortrait : styles.cartContainerLandscape}>
            {cart.map((pizzaInCart, index) => (
            <View key={index} style={styles.cartItem}>
                <Image source={{ uri: pizzaInCart.image }}
                 style={styles.image} />
                <Text>{pizzaInCart.name}</Text>
                <Text>{pizzaInCart.price}</Text>
            </View>
            ))}
            <Text>Total: {calculaTotal()}</Text>
            <Button title="Limpar Pedido" onPress={onClearCart} />
            {selectedPizza && !isPortrait && (
                <View style={styles.selectedPizzaContainer}>
                    <Image source={{ uri: selectedPizza.image }} style={styles.selectedPizzaImage} />
                    <Text>{selectedPizza.ingredients}</Text>
                    <Button title="Close" onPress={onCloseModal} />
              </View>
            
            )}
        </View>
    )
}
const styles = StyleSheet.create({
    cartContainerPortrait: {
      padding: 10,
      borderTopWidth: 1,
      borderTopColor: '#ccc',
      height: '30%',
    },  cartContainerLandscape: {
        padding: 10,
        borderLeftWidth: 1,
        borderLeftColor: '#ccc',
        width: '30%',
      },
      image: {
      width: 20,
      height: 20,
      marginRight: 5,
    },
    selectedPizzaContainer: {
        marginBottom: 20,
        marginTop: 20,
      },
      selectedPizzaImage: {
        width: '100%',
        height: undefined,
        aspectRatio: 1,
        minHeight: 20,
        maxHeight: 100,
        marginBottom: 10,
      },
});