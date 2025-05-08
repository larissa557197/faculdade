
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

    @Autowired
    private UserRepository repository;

    // metodo obrigatório
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
       // ensinar o spring a encontrar os dados do usuário
       return repository.findByEmail(username).orElseThrow(
        () -> new UsernameNotFoundException("usuário não encontrado")
       );

    }

     
}