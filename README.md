# Remix of Alvim Flow Manager

Você é o criador de um aplicativo chamado **Alvim Automação – Área de Fluxos**.  
Este app substitui 3 Typebots e precisa ser extremamente organizado, bonito e funcional.

===========================
🎨 IDENTIDADE VISUAL
===========================
Use a logo:
https://s3.alvimnutri.com.br/automacao/Public/Logo%20preta%20vertical%20sem%20fundo.png

Use um layout elegante, profissional e minimalista.
Fundo branco, muito espaçamento e cards com bordas suaves.
Tipografia grande e limpa.

===========================
🧱 ESTRUTURA DO APP
===========================

O app terá duas áreas principais:
1) Área do Usuário – onde os formulários ficam
2) Painel Administrativo – onde o nutricionista configura webhooks

Crie um menu ou navegação clara para alternar entre as áreas.

===========================
📌 BANCO DE DADOS (TABELAS)
===========================

Crie duas tabelas internas:

TABELA: webhooks
Campos:
- id (número)
- nome (texto)
- url (texto)
- metodo (texto)

Insira 3 linhas iniciais:
1 | agendar_consulta | https://webhook.alvimnutri.com.br/webhook/agendarconsulta | POST
2 | agendar_retorno  | https://webhook.alvimnutri.com.br/webhook/retorno         | POST
3 | enviar_audio     | https://webhook.alvimnutri.com.br/webhook/enviaaudio      | GET

TABELA: configs
Campos:
- chave (texto)
- valor (texto)

Insira:
timezone | America/Sao_Paulo

===========================
🏠 PÁGINA INICIAL (USUÁRIO)
===========================

Exibir a logo no topo.

Criar 3 cards grandes, clicáveis:

CARD 1 — 📅 Agendar Consulta  
Ao clicar → abrir Formulário “Agendar Consulta”

CARD 2 — 🔁 Agendar Retorno  
Ao clicar → abrir Formulário “Agendar Retorno”

CARD 3 — 🎤 Enviar Áudio  
Ao clicar → abrir Formulário “Enviar Áudio”

Cada card deve ser elegante, com sombra leve, bordas arredondadas, e ícone grande.

===========================
📝 FORMULÁRIO 1 — AGENDAR CONSULTA
===========================

Campos:
- Nome (texto)
- Sobrenome (texto)
- Telefone com DDD (campo texto, pré-preencher com +55)
  → apenas números, sem hífen
- Data da Consulta (formato DD/MM/AAAA)
- Horário (formato HH:MM)

Botão: **Enviar**

Ação ao enviar:
1. Carregar da tabela `webhooks` o registro “agendar_consulta”.
2. Usar o campo `url` e `metodo`.
3. Enviar o seguinte JSON ao webhook:

{
  "nome": "{{nome}}",
  "sobrenome": "{{sobrenome}}",
  "telefone": "{{telefone}}",
  "data": "{{data}}",
  "horario": "{{horario}}"
}

4. Exibir mensagem de sucesso:
"Consulta enviada com sucesso! Em breve entraremos em contato."

===========================
📝 FORMULÁRIO 2 — AGENDAR RETORNO
===========================

Mesmos campos do primeiro formulário:

- Nome
- Sobrenome
- Telefone com +55 e números corridos
- Data
- Horário

Ação ao enviar:
1. Ler webhook “agendar_retorno”
2. Enviar JSON idêntico ao anterior
3. Exibir mensagem:
"Retorno enviado com sucesso!"

===========================
📝 FORMULÁRIO 3 — ENVIAR ÁUDIO
===========================

Campos:
- Nome do Paciente
- Telefone (+55 pré-carregado, números corridos)
- Mensagem (textarea grande)

Método GET usado dinamicamente da tabela.

Construir URL como:
{{url}}?nome={{nome}}&telefone={{telefone}}&mensagem={{mensagem}}

Exibir mensagem:
"Áudio enviado com sucesso!"

===========================
⚙️ PAINEL ADMINISTRATIVO
===========================

Criar página exclusiva chamada **Admin**.

Exibir:

SEÇÃO 1 — Configurações do Sistema  
- Campo: Fuso horário (mostrar valor atual da tabela configs)
- Mostrar horário atual no fuso selecionado
- Botão Salvar

SEÇÃO 2 — Webhooks  
Uma tabela editável com colunas:
- Nome do fluxo
- URL do webhook (editável)
- Método (GET ou POST – dropdown)
- Botão “Salvar alterações”
- Botão “Testar webhook”

Permitir que o nutricionista altere URLs e métodos sem tocar no código.

===========================
🧠 FUNCIONALIDADES OBRIGATÓRIAS
===========================

1. Sempre carregar e aplicar o fuso horário **America/Sao_Paulo**.  
   Exibir horários e validar datas conforme Brasil.

2. Telefone sempre com:
   +55 + DDD + número  
   → sem hífen, sem espaço interno.

3. Toda vez que um formulário é enviado:
   - Carregar o webhook correto da tabela
   - Usar o método configurado
   - Enviar os dados conforme especificado

===========================
🎯 COMPORTAMENTO FINAL
===========================

O app deve ficar:
- limpo
- muito fácil de usar
- visualmente profissional
- organizado em cartões
- totalmente configurável via painel administrativo
- padronizado no fuso horário do Brasil

Sempre manter harmonia visual da identidade “Alvim Automação”.

===========================
FIM DO PROMPT
===========================

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/15cad786-0ab3-42a5-9e7d-1e17d9869620).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
