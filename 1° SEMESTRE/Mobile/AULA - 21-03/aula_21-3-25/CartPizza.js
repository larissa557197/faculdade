// CartPizza.js
import React from 'react';
import { View, Text, Image, Button, StyleSheet } from 'react-native';

const CartPizza = ({ cart, selectedPizza, isPortrait, onCloseModal, onClearCart }) => {
  const calculateTotal = () => {
    return cart.reduce((total, pizza) => total + pizza.price, 0).toFixed(2);
  };

  return (
    <View style={isPortrait ? styles.cartContainerPortrait : styles.cartContainerLandscape}>
      {selectedPizza && !isPortrait && (
        <View style={styles.selectedPizzaContainer}>
          <Image source={{ uri: selectedPizza.image }} style={styles.selectedPizzaImage} />
          <Text>{selectedPizza.ingredients}</Text>
          <Button title="Close" onPress={onCloseModal} />
        </View>
      )}
      <Text>Cart:</Text>
      {cart.map((pizza, index) => (
        <Text key={index}>{pizza.name} - ${pizza.price.toFixed(2)}</Text>
      ))}
      <Text>Total: ${calculateTotal()}</Text>
      <Button title="Clear Cart" onPress={onClearCart} />
    </View>
  );
};

const styles = StyleSheet.create({
  cartContainerPortrait: {
    padding: 10,
    borderTopWidth: 1,
    borderTopColor: '#ccc',
  },
  cartContainerLandscape: {
    padding: 10,
    borderLeftWidth: 1,
    borderLeftColor: '#ccc',
    width: '30%',
  },
  selectedPizzaContainer: {
    marginBottom: 20,
  },
  selectedPizzaImage: {
    width: '100%',
    height: 200,
    marginBottom: 10,
  },
});

export default CartPizza;