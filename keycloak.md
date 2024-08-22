# Keycloak

<https://www.keycloak.org/documentation>

<https://www.keycloak.org/docs/latest/server_admin/index.html>

<https://www.keycloak.org/docs/latest/securing_apps/index.html>

<https://www.keycloak.org/docs/latest/authorization_services/index.html>

- RBAC / ABAC solution
- Java app
- nice UI
- CLI
- Rest API
- docs, Getting Started docs are thin, go to [Server Administration](https://www.keycloak.org/docs/latest/server_admin/index.html) docs

<!-- INDEX_START -->

- [Terminology](#terminology)
- [Kubernetes Config](#kubernetes-config)
- [Azure AD integration](#azure-ad-integration)
  - [AAD user pre-provisioning to Keycloak](#aad-user-pre-provisioning-to-keycloak)

<!-- INDEX_END -->

## Terminology

- Realm - grouping of users, groups, permissions and credentials
- Client - app requesting authentication and authorization from Keycloak. Tokens (JWT) can be shared between users
- Resource - a user-defined object within keycloak, can be something general like a full feature, or can be a more specific asset
- Authorization Scope - the scope of access on a resource (eg. read, write)
- Policy - a rule to assign Permissions to resources, by user/group/role. For ABAC, must use JavaScript policies
- Permissions - created to allow policies to grant access to resources - Affirmative, Consensus, or Unanimous policy decision making

## Kubernetes Config

[HariSekhon/Kubernetes-configs](https://github.com/HariSekhon/Kubernetes-configs/blob/master/keycloak)

## Azure AD integration

Create Enterprise App + App Registration as usual

Microsoft provider configuration resulted in `An internal server error has occurred` upon logouts so went with OIDC provider.

In the realm in the Keycloak UI:

- Configure
   - Identity Providers
      - Add Provider (top right)
          - OpenID Connect v1.0 (aka OIDC)
             - set Display Name to "Azure AD" (for convenience only)
             - Import from URL near bottom - paste URL from AAD App Registration's Overview - Endpoints button at top - OpenID Connect metadata document (half way down)
             - Client Authentication = "Client secret sent as post"
             - Client ID - paste the AAD app's Overview "Application (client) ID" - XXX: Note the client id is that of the App not that of the secret
             - Client Secret
                - in AAD App Reg go to Clients & Secrets
                   - New client secret
                      - paste the Value into the Client Secret box
             - Copy the "Redirect URI" from the top of this page into the AAD app's Authentication page - Add a platform - Web - Redirect URIs
  - Authentication
     - "Identity Provider Redirector" line of the grid
        - Alternative
        - Actions
           - Config
              - Default Identity Provider = oidc (the reference to the provider created above)

### AAD user pre-provisioning to Keycloak

- dump out user attribute list from AAD to decide on attributes
- AAD attributes sync to Keycloak

###### Ported from private Knowledge Base pages 2022+
