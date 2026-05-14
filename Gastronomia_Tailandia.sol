// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Gastronomia_Tailandia
 * @dev Registro de equilibrio químico de sabores y emulsiones de coco.
 * Serie: Sabores de Asia (#15) - Nodo Sudeste Asiático
 */
contract Gastronomia_Tailandia {

    error RangoExcedido(string parametro, uint256 valor);
    error YaVotado(address voter);
    error IDInvalido(uint256 id);
    error NombreRequerido();

    struct Plato {
        string nombre;
        string ingredientes;
        string preparacion;
        uint256 puntuacionEquilibrio;   // Armonia Salado/Dulce/Acido/Picante (1-100)
        uint256 porcentajeGrasaCoco;    // Nivel de emulsion de coco (0-100)
        bool utilizaPastaFresca;        // Validador de hierbas majadas en mortero
        uint256 likes;
        uint256 dislikes;
    }

    mapping(uint256 => Plato) public registroCulinario;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    
    uint256 public totalRegistros;
    address public owner;

    constructor() {
        owner = msg.sender;
        // Inauguramos con el Pad Thai (Ingeniería de Equilibrio)
        registrarPlato(
            "Pad Thai", 
            "Fideos de arroz, tamarindo (acido), azucar de palma (dulce), salsa de pescado (salado), chile (picante).",
            "Salteado rapido en wok donde la clave es el equilibrio exacto de la salsa antes de la caramelizacion.",
            98, 
            0, 
            false
        );
    }

    function registrarPlato(
        string memory _n, 
        string memory _i, 
        string memory _p, 
        uint256 _equilibrio, 
        uint256 _coco,
        bool _pasta
    ) public {
        if (bytes(_n).length == 0) revert NombreRequerido();
        if (_equilibrio > 100) revert RangoExcedido("Equilibrio", _equilibrio);
        if (_coco > 100) revert RangoExcedido("Grasa Coco", _coco);

        totalRegistros++;
        registroCulinario[totalRegistros] = Plato({
            nombre: _n,
            ingredientes: _i,
            preparacion: _p,
            puntuacionEquilibrio: _equilibrio,
            porcentajeGrasaCoco: _coco,
            utilizaPastaFresca: _pasta,
            likes: 0,
            dislikes: 0
        });
    }

    function darLike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].likes++;
        hasVoted[_id][msg.sender] = true;
    }

    function darDislike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].dislikes++;
        hasVoted[_id][msg.sender] = true;
    }
}
