package br.com.fiap.fin_money_api.config;



import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    // porque tem que achar um usuario em uma tabela do banco, não em memória
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception{
        // define o filtro de segurança da aplicação (autorizações e autenticações)
        return http.authorizeHttpRequests(
            auth -> auth
                //.requestMatchers("/categories/**").hasRole("ADMIN")

                // todas as requisições devem estar autenticadas
                .anyRequest().authenticated()
        )
        // desabilita o CSRF (evita erros em requisições POST sem token CSRF)
        .csrf(csrf -> csrf.disable())
        // usa autenticação básica (usuário e senha no cabeçalho da requisição)
        .httpBasic(Customizer.withDefaults())
        // contrói o filtro de segurança
        .build();
    }
    
    // @Bean
    // UserDetailsService userDetailsService(){
    //     var users = List.of(
    //         User
    //             .withUsername("joao")
    //             .password("$2a$12$1DLNWZDzr4xwa.hhL1Y6Run9t8q2dc2vw54QwUh9fnxW3cy5B8z1q")
    //             .roles("ADMIN")
    //             .build(),
    //         User
    //             .withUsername("maria")
    //             .password("$2a$12$OyjhEIaHF.3/AxaNW.G.K.Zu.Pzv.B7.v9YPjXC6jm7svEhTE1Tcq")
    //             .roles("USER")
    //             .build()


    //     );
    //     return new InMemoryUserDetailsManager(users);
    // }



    // quando precisar do passwordEncoder vai retornar nessa criptografia
    @Bean
    PasswordEncoder passwordEncoder(){
        // retorna um codificador de senha usando algoritmo BCrypt
        return new BCryptPasswordEncoder();
    }

}
