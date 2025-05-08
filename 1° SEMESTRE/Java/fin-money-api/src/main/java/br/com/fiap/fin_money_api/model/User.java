package br.com.fiap.fin_money_api.model;

import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
// altero o sparametros que o jpa vai usar pra criar a tabela
@Table(name = "users")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Data
// promovendo o User pra ser do spring
// pode ser feito ou por interface ou por implements
public class User implements UserDetails {
    
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Email(message = "email inválido")
    @NotBlank(message = "campo obrigatório")
    // altero os parametros que o jpa vai usar pra criar o campo
    @Column( unique =  true)
    private String email;

    @Size(min = 5)
    private String password;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // retorna uma lista de autorizações
        return List.of(new SimpleGrantedAuthority("USER")); // todo mundo é usuário "NORMAL"
    }

    @Override
    public String getUsername() {
        return email;
    }
    
}
