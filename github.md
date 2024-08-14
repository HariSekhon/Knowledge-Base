# GitHub

NOT PORTED YET

## GitHub SSH Key SSO Authorization

If you're using SSH keys to `git clone` in a company using GitHub SSO authentication then you will need
to authorize your SSH keys for each organization in order to be able to use them.

On this page listing your SSH keys:

<https://github.com/settings/keys>

On the right of each key, click the `Configure SSO` drop-down and then next to the organizations you're a member of
click `Authorize`.

<https://docs.github.com/en/enterprise-cloud@latest/authentication/authenticating-with-saml-single-sign-on/authorizing-an-ssh-key-for-use-with-saml-single-sign-on>

## CodeOwners

[HariSekhon/Templates - .github/CODEOWNERS](https://github.com/HariSekhon/Templates/blob/master/.github/CODEOWNERS)

Enforce Pull Request reviews to all or given paths in the repo to this list of users or teams.

Auto-notifies these code owners requesting reviews when pull requests changing their files are raised.

### CodeOwners Gotcha - Secret Teams

When listing GitHub teams in the `.github/CODEOWNERS` file, the team must not be set to Secret otherwise it won't be
respected, on top of it requiring Write access to the repo.
