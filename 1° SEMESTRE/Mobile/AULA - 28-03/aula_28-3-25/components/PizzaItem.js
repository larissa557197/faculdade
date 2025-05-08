// PizzaItem.js
import React from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity } from 'react-native';
import { useCart } from '../providers/CartProvider';

const PizzaItem = ({ pizza }) => {
  const { addToCart } = useCart();

  return (
    <TouchableOpacity onPress={() => addToCart(pizza)} style={styles.itemContainer}>
      <Image source={{ uri: pizza.image }} style={styles.image} />
      <View style={styles.info}>
        <Text style={styles.name}>{pizza.name}</Text>
        <Text style={styles.description}>{pizza.description}</Text>
        <Text style={styles.price}>${pizza.price.toFixed(2)}</Text>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  itemContainer: {
    flexDirection: 'row',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  image: {
    width: 80,
    height: 80,
    marginRight: 10,
  },
  info: {
    flex: 1,
    justifyContent: 'center',
  },
  name: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  description: {
    fontSize: 14,
    color: '#666',
  },
  price: {
    fontSize: 16,
    color: '#000',
  },
});

export default PizzaItem;