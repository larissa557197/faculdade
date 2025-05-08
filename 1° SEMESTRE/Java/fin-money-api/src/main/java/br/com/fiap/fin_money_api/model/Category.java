package br.com.fiap.fin_money_api.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Category {

    //define o campo 'id' com chave primária da tabela, com geração automática
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // valida que o campo 'name' não pode estar em branco e deve ter no mínimo 3 caracteres
    @NotBlank(message = "Não pode estar em branco")
    @Size(min = 3)
    private String name;
    
    // valida que o ícone comece com uma letra maiúscula e não pode estar em branco
    @NotBlank(message = "Não pode estar em branco")
    @Pattern(regexp = "^[A-Z].*", message = "Deve começar com letra maiúscula")
    private String icon;
    // define um relacionamento MUITOS-pra-UM com a entidade User (muitas categorias para um usuário)
    @ManyToOne
    @JsonIgnore // ignora o campo 'user' na serialização JSON para evitar loops infinitos
    private User user;
   
    
}
