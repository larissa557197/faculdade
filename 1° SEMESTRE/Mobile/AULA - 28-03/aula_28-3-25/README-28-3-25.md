Navigation:

# Para quem for tentar fazer

npm install @react-navigation/native @react-navigation/bottom-tabs react-native-paper react-native-vector-icons


const pizzas = [
{ id: '1', name: 'Margherita', description: 'Tomate, mussarela, manjericão', price: 8.99, image: 'https://s2-receitas.glbimg.com/RL-dN3YlvejAXwiPYoguGlE2p_0=/0x0:1280x800/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_1f540e0b94d8437dbbc39d567a1dee68/internal_photos/bs/2022/C/H/HXf1trQZGtIylAzO2SUg/pizza-margherita-receita.jpg', ingredients: 'Tomate, mussarela, manjericão' },
{ id: '2', name: 'Pepperoni', description: 'Pepperoni, mussarela, molho de tomate', price: 9.99, image: 'https://www.minhareceita.com.br/app/uploads/2022/12/pizza-de-pepperoni-caseira-portal-minha-receita.jpg', ingredients: 'Pepperoni, mussarela, molho de tomate' },
{ id: '3', name: 'Havaiana', description: 'Presunto, abacaxi, mussarela', price: 10.99, image: 'https://img.kidspot.com.au/pZnR2nZu/kk/2015/03/hawaiian-pizza-recipe-605894-2.jpg', ingredients: 'Presunto, abacaxi, mussarela' },
{ id: '4', name: 'Vegetariana', description: 'Pimentões, azeitonas, cebolas, cogumelos, mussarela', price: 11.99, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGsO8_BXeu1PTx2mLrb7OPazuxz4hJp273FQ&s', ingredients: 'Pimentões, azeitonas, cebolas, cogumelos, mussarela' },
{ id: '5', name: 'Frango com BBQ', description: 'Frango, molho BBQ, cebolas roxas, coentro, mussarela', price: 12.99, image: 'https://www.thecandidcooks.com/wp-content/uploads/2023/04/bbq-chicken-pizza-feature.jpg', ingredients: 'Frango, molho BBQ, cebolas roxas, coentro, mussarela' },
{ id: '6', name: 'Quatro Queijos', description: 'Mussarela, parmesão, gorgonzola, queijo de cabra', price: 13.99, image: 'https://au.gozney.com/cdn/shop/articles/Four_Cheese_Pizza_Feng_Chen_-_Large1.jpg?v=1696535135', ingredients: 'Mussarela, parmesão, gorgonzola, queijo de cabra' },
{ id: '7', name: 'Frango Buffalo', description: 'Frango buffalo, mussarela, queijo azul, cebolas roxas', price: 14.99, image: 'https://dontwastethecrumbs.com/wp-content/uploads/2019/08/Buffalo-Chicken-Cover.jpg', ingredients: 'Frango buffalo, mussarela, queijo azul, cebolas roxas' },
{ id: '8', name: 'Carnes', description: 'Pepperoni, linguiça, presunto, bacon, mussarela', price: 15.99, image: 'https://www.thespruceeats.com/thmb/xuxwh4RIGcZMgaJE8u3SueM0SoA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/aqIMG_4568fhor-0b89dc5c8c494ee9828ed29805791c5a.jpg', ingredients: 'Pepperoni, linguiça, presunto, bacon, mussarela' },
{ id: '9', name: 'Mediterrânea', description: 'Queijo feta, azeitonas, espinafre, tomates secos, mussarela', price: 12.99, image: 'https://www.diadepeixe.com.br/extranet/thumbnail/crop/550x360/Receita/pizza_camarao_1495135807214.jpg', ingredients: 'Queijo feta, azeitonas, espinafre, tomates secos, mussarela' },
{ id: '10', name: 'Italiana Picante', description: 'Linguiça picante, pepperoni, jalapenos, mussarela', price: 13.99, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCzHWAWDHkqu0s0XAbPkBC5CEpzrfgIPTUqw&s', ingredients: 'Linguiça picante, pepperoni, jalapenos, mussarela' },
];