
package br.com.fiap.fin_money_api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import br.com.fiap.fin_money_api.model.Credentials;
import br.com.fiap.fin_money_api.model.Token;
import br.com.fiap.fin_money_api.model.User;
import br.com.fiap.fin_money_api.service.TokenService;


@RestController
public class AuthController {

    @Autowired
    private TokenService tokenService;

    @Autowired
    private AuthenticationManager authenticationManager;
    
    @PostMapping("/login")
    public Token login(@RequestBody Credentials credendials){ // DTO
        
        var auth = new UsernamePasswordAuthenticationToken(credentials.email(), credentials.password());

        var user = (User) authenticationManager.authenticate(auth).getPrincipal();
        
        // retorna o token recebido no corpo da requisição
        return tokenService.createToken(user);
    }
    
}
// JWT : cominicação com a web SEGURA e AUTOCONTIDA// se eu mandar o objeto json esses dois pontos podem garantir que no meio do caminho as informações como o email não foi alterada 
// garante que a informação vai de ponto a ponto
// alguem pode ver essa informação, mas alterar não pode 

/*
 parte verde -> cabeçalho
 em branco -> dados que eu quero transmitir pro outro
    informações que podem traficar sem risco

    assinatura do token que foi gerado pela MINHA aplicação, não por outra pessoa forjando a autenticação
*/