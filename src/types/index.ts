export interface Webhook {
  id: number;
  nome: string;
  url: string;
  metodo: 'GET' | 'POST';
}

export interface Config {
  chave: string;
  valor: string;
}

export interface FormularioConsulta {
  tipo: 'consulta' | 'retorno';
  nome: string;
  sobrenome: string;
  telefone: string;
  email: string;
  data: string;
  horario: string;
  profissional: string;
  observacao: string;
}

export interface FormularioAudio {
  nome: string;
  telefone: string;
  profissional: string;
  mensagem: string;
}
