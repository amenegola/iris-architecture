# iris-architecture

## Introdução

Este repositório contém código Terraform que implementa o modelo de classificação Iris do repositório [iris-challenge](https://github.com/amenegola/iris-challenge).

Toda a arquitetura foi criada utilizando Google Cloud Platform (GCP), pois foi mencionado na última conversa que estão avaliando GCP, então esta solução de desafio vira uma prova de conceito na utilização de ferramentas GCP para deploy de modelos.

Para ilustração, realizei o deploy de duas formas, utilizando o *Cloud Run*, e utilizando *Google Kubernetes Engine (GKE)*.

## Solução Cloud Run

Cloud Run é o produto de implantação de microsserviços gerenciado pela GCP. Seu deploy é muito simples, basta que você tenha uma imagem Docker no Google Container Registry, com um serviço qualquer (por exemplo, FastAPI), exposto em uma porta. O deploy é realizado no GCP Cloud Shell com os comandos:

```
git clone https://github.com/amenegola/iris-architecture.git
cd iris-architecture/envs/prod/cloudrun
terraform init
terraform plan
terraform apply
```

Para testar, acesse:

https://iris-model-nqsfhkuvaq-uc.a.run.app/docs

Autorize com a chave de API 134740f4-1c3c-4dba-ad02-875809d2bf0b
e execute a rota `/api/model/predict`.

## Solução Google Kubernetes Engine (GKE)

Uma solução com maior nível de complexidade, mas explora a possibilidade de usar Terraform para criação de Clusters GKE, tornando a barreira inicial de criação de infraestrutura uma tarefa fácil de ser superada.

Por exemplo, podemos criar um cluster grande para todos os modelos, mas podemos criar clusters menores para, por exemplo, cada frente dentro da empresa, desacoplando serviços, reduzindo complexidade, e permitindo customização de acordo com objetivos.

Para criar o cluster GKE, basta rodar os comandos abaixos:

```
git clone https://github.com/amenegola/iris-architecture.git
cd iris-architecture/envs/prod/kubernetes
terraform init
terraform plan
terraform apply
export KUBECONFIG="${PWD}/kubeconfig-prd"
kubectl create secret generic sa-key --from-file=key.json=service_account.json
```
Com a execução destes comandos, você criou o cluster GKE, colocou um arquivo `kubeconfig` como variável de ambiente para autenticação ao cluster, e registrando no GKE um Secret com uma conta de serviço que possui acesso ao Google Cloud Storage (GCS).

Finalmente, para fazer o deploy do modelo, acesse a pasta `kubernetes` do repositório [iris-challenge](https://github.com/amenegola/iris-challenge), e rode o seguinte comando:

```
kubectl apply -f iris-service.yaml
```

Com isso, o serviço com o modelo será criado para acesso externo.

Para testar, acesse:

http://104.198.132.8:8000/docs

Autorize com a chave de API 134740f4-1c3c-4dba-ad02-875809d2bf0b
e execute a rota `/api/model/predict`

## Referências

O repositório referente ao modelo implantado se encontra [neste link](https://github.com/amenegola/iris-challenge)
