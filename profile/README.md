# Welcome to the Open Crypto Broker Project on GitHub

:wave: Welcome to the official GitHub presence of the Open Crypto Broker project. We are part of [ApeiroRA](https://apeirora.eu/content/projects/) which is an Important Project of Common European Interest - Next Generation Cloud Infrastructures and Services (IPCEI-CIS). 
Open Crypto Broker (OCB) is a solution that supports crypto agility enabling applications to quickly adapt to new cryptographic standard and requirements.

## :globe_with_meridians: ApeiroRA?

ApeiroRA is a reference blueprint for an open, flexible, secure, and compliant next-generation cloud-edge continuum and therefore a key contribution to IPCEI-CIS. At a high level, the projects of ApeiroRA allow users to provider-agnostically fetch, request and consume services, and for service providers to describe, offer and provision their services.

Learn more about ApeiroRA by checking out the official website at [https://apeirora.eu/](https://apeirora.eu/).

## :handshake: Open Crypto Broker



As cryptographic standards evolve and new vulnerabilities emerge, organizations must ensure that their software can quickly adapt to maintain strong security postures. 
Open Crypto Broker (OCB) supports Crypto Agility by enabling software to seamlessly transition to new cryptographic algorithms, protocols, or standards as security requirements change. 
This adaptability is essential to protect sensitive data, maintain compliance, and mitigate the risks associated with outdated or vulnerable cryptographic mechanisms.
Open Crypto Broker abstracts away cryptographic details from applications, which are no longer hardcoded in the application, but specified in a configurable file called crypto profile.
The crypto profile is defined based on standards like FIPS or PCI. Applications make agnostic crypto calls to the OCB which implements the profile using a crypto library, logs relevant information for auditing/alerting, and checks for profile compliance.

## :pushpin: Open Crypto Broker and NeoNephos

Open Crypto Broker has been donated to the NeoNephos Foundation, a Linux Foundation initiative dedicated to advancing open-source projects that align with the strategic objectives of IPCEI-CIS under neutral governance. Learn more about NeoNephos and our role within it [here](https://neonephos.org).

## :bear: Features

- **Crypto-agility:** OCB enables rapid adaptation to new algorithms and security standards
- **Abstracted Implementation:** OCB separates crypto logic from application code
- **Configurable Profiles:** OCB defines crypto operations through external configuration enabling zero-code algorithm migration
- **gRPC-based communication:** OCB server and client communicate over Unix Domain Sockets for performance and security
- **Standards Compliance:** OCB enables compliance of existing standards like FIPS and PCI
- **Multiple languages:** While the server is written in Go, OCB offers clients in different languages (currently Go and JavaScript)
- **Full OpenTelemetry instrumentation:** OCB supports OpenTelemetry for distributed tracing, metrics, and structured logging
- **Multiple deployment models:** OCB supports deployment on Docker, Kubernetes/Kyma, and Cloud Foundry

## :busts_in_silhouette: Get Involved

Thank you for considering to contribute to our project.
To become an excellent contributor, check out our [contribution guidelines](https://github.com/open-crypto-broker/.github/blob/main/CONTRIBUTING.md) and our [open issues](https://github.com/issues?q=is:open+is:issue+org:open-crypto-broker).

## :blue_heart: Code of Conduct

To facilitate a nice environment for all, check out [our Code of Conduct](https://github.com/open-crypto-broker/.github/blob/main/CODE_OF_CONDUCT.md).

## :books: Learn More

To learn more about OCB, check out OCB documentation at [https://github.com/open-crypto-broker/crypto-broker-documentation/](https://github.com/open-crypto-broker/crypto-broker-documentation/). 

<p align="center">
  <img alt="Bundesministerium für Wirtschaft und Energie (BMWE)-EU funding logo" src="https://apeirora.eu/assets/img/BMWK-EU.png" width="400"/>
</p>

