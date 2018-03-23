# Public GitLab Project
## McGraw-Hill Education, Farcical Education Labs

This is an internet-facing deployment of GitLabs with some previously private repositories that MHE/FEL wants to make public. For some reason, these couldn't just go on GitHub.

## Networks To Know

  **note**: in previous communication, `256` was used as the first octet of these networks. In this implementation, that will be `10`.

  Generally, clients will connect to the git services via TCP:443 and TCP:22 on the internet.

  Administrators will use TCP:122 and TCP:8443 for SSH and admin web access.

  Services required by the system may include TCP:25 at Amazon SES (see [here](https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-connect.html) for SMTP endpoints) and UDP:161 for SNMP monitoring.

### Corporate client networks

  - Corporate office LAN    :: 10.20.0.0/15  (Note: this was given as 256.21.0.0/15 which, even disregarding the first octet, doesn't seem to be valid.)
  - Corporate VPN endpoints :: 10.23.0.0/16
  - Corporate office Wifi   :: 10.22.0.0/18

  All require TCP egress to [10.28/28, 10.28.0.16/28] on [122, 8443]

### Deployment networks

  - AZ A :: 10.28.0.0/28
      - TCP ingress from 0.0.0.0/0 on [22, 443]
      - TCP ingress from [10.21/15, 10.23/16, 10.22/18] on [122, 8443]
  - AZ B :: 10.28.0.16/28
      - TCP ingress from 0.0.0.0/0 on [22, 443]
      - TCP ingress from [10.21/15, 10.23/16, 10.22/18] on [122, 8443]

## Application Architecture

It's HA GitLab, with an active/passive HA system. The active and passive nodes should be in separate AZs, and therefore subnets. They will need security groups to allow HA synchronization.

For an active/passive system with an unspecified DNS provider, the best bet for a reverse proxy is the good ol' ELB, with a healthcheck. The ELB will not do SSL termination in this setup.

See [diagram](./doc/ArchitectureDiagram.pdf).




