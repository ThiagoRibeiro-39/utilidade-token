// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BitCof {
    // Variáveis de estado
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    address private _owner;

    // Informações públicas do token
    string public name = "BitCof";
    string public symbol = "BCF";
    uint8 public decimals = 8;

    // Mapeamento de permissões para gastos de tokens
    mapping (address => mapping(address => uint256)) private _allowance;

    // Eventos para notificar alterações de estado
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);

    // Modificador de acesso restrito ao dono do contrato
    modifier onlyOwner {
        require(msg.sender == _owner, "Not the owner");
        _;
    }

    // Construtor do contrato
    constructor() {
        _owner = msg.sender;
        _totalSupply = 1_000_000 * 10 ** decimals;
        _balances[_owner] = _totalSupply;
    }

    // Função para obter o total de tokens em circulação
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    // Função para verificar o saldo de tokens de um endereço
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    // Função para verificar a permissão para gastar tokens
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowance[owner][spender];
    }

    // Função para realizar uma transferência de tokens
    function transfer(address to, uint256 value) external returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    // Função para dar permissão para um endereço gastar tokens
    function approve(address spender, uint256 value) external returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    // Função para realizar uma transferência de tokens de um endereço para outro
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowance[from][msg.sender] - value);
        return true;
    }

    // Função para queimar (burn) tokens (somente pelo dono)
    function burn(uint256 value) external onlyOwner {
        require(value <= _balances[_owner], "Insufficient balance to burn");
        _balances[_owner] -= value;
        _totalSupply -= value;
        emit Burn(_owner, value);
    }

    // Função interna para realizar uma transferência de tokens
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "Transfer to the zero address");
        require(value <= _balances[from], "Insufficient balance");

        _balances[from] -= value;
        _balances[to] += value;

        emit Transfer(from, to, value);
    }

    // Função interna para dar permissão para gastar tokens
    function _approve(address owner, address spender, uint256 value) internal {
        _allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
}
