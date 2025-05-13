
package br.com.fiap.fin_money_api.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import br.com.fiap.fin_money_api.repository.UserRepository;

// onde ele encontra os detalhes do usuário
// AuthService É um UserDatailsService
// pra participar desse "clube" precisa implementar um método especíico pra essa classe ser implementada 

@Service
public class AuthService implements UserDetailsService  {

    // injeta automaticamente o repositório de usuários para acessar dados no banco
    @Autowired
    private UserRepository repository;

    
    // metodo obrigatório -> implementa o método loadUserByUsername da interface UserDatailsService
    // esse método é responsável por carregar os detalhes de um usuário com base no nome de usuário (email)
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
       // ensinar o spring a encontrar os dados do usuário
       // tenta encontrar um usuário no banco pelo email(username)
       // se não encontrar, lança uma exceção de usuário não encontrado
       return repository.findByEmail(username).orElseThrow(
        // mensagem de erro personalizada caso o usuário não seja encontrado 
       () -> new UsernameNotFoundException("usuário não encontrado")
       );

       
    }

     
}