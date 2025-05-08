// HomeScreen.js
import React, { useState } from 'react';
import { FlatList, StyleSheet, TextInput, View } from 'react-native';
import PizzaItem from '../components/PizzaItem';

export default function HomeScreen({ pizzas }) {
  const [searchQuery, setSearchQuery] = useState('');

  // Filter pizzas based on the search query
  const filteredPizzas = pizzas.filter(pizza =>
    pizza.description.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const renderItem = ({ item }) => <PizzaItem pizza={item} />;

  return (
    <View style={{ flex: 1, padding: 10 }}>
      <TextInput
        style={styles.searchBox}
        placeholder="Search pizzas by description"
        value={searchQuery}
        onChangeText={setSearchQuery}
      />
      <FlatList
        data={filteredPizzas}
        renderItem={renderItem}
        keyExtractor={item => item.id}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  searchBox: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 5,
    padding: 10,
    marginBottom: 10,
  },
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