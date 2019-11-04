%%%
Title = "Resource Public Key Infrastructure (RPKI) Repository Requirements"
category = "std"
docName = "draft-bruijnzeels-deprecate-rsync-00"
abbrev = "RPKI Repository Requirements"
ipr = "trust200902"
updates = [6841]

[[author]]
initials="T."
surname="Bruijnzeels"
fullname="Tim Bruijnzeels"
organization = "NLnet Labs"
  [author.address]
  email = "tim@nlnetlabs.nl"
  uri = "https://www.nlnetlabs.nl/"


[pi]
 toc = "yes"
 compact = "yes"
 symrefs = "yes"
 sortrefs = "yes"

%%%

.# Abstract

This document updates the profile for the structure of the Resource
Public Key Infrastructure (RPKI) distributed repository [@!RFC6481]
by describing how the RPKI Repository Delta Protocol (RRDP) [@!RFC8182]
can be used, and stipulating that repositories which are made available
over RRDP are no longer required to be available over rsync.

The Profile for X.509 PKIX Resource Certificates [@!RFC6487] uses rsync
URIs in the Authority Information Access, Subject Information Access,
and CRL Distribution Points extensions. This document leaves this unchanged,
meaning that rsync URIs are still used for naming and finding objects in the RPKI.
However, it is no longer guaranteed that objects can be retrieved using these
URIs.

{mainmatter}

# Requirements notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in
this document are to be interpreted as described in BCP 14 [@!RFC2119] [@!RFC8174] when, and only when, they appear in all capitals, as shown here.

# Motivation

The Resource Public Key Infrastructure (RPKI) [@!RFC6480] as originally defined
uses rsync as its distribution protocol, as outlined in [@!RFC6481]. Later, the
RPKI Repository Delta Protocol (RRDP) [@!RFC8182] was designed to provide an
alternative. In order to facilitate incremental deployment RRDP has been
deployed as an additional optional protocol, while rsync was still mandatory to
implement.

RPKI Repository operators are still required to provide 24/7 up-time to their
rsync infrastructure, as long as the requirement to support rsync stands. Thus,
the benefit that they get from supporting RRDP, which enables the use of content
delivery networks (CDNs) for this purpose, is limited.

And as long as not all RPKI Repositories support RRDP, Relying Party software is
still required to support rsync. Because there is a lack of rsync client
libraries, this is typically implemented by calling a system installed rsync
binary. This is inefficient, and has issues with regards to versioning of the
rsync binary, as well as reporting errors reliably.

This document requires that all RPKI repositories and all Relying Parties support
RRDP. It also stipulates that these parties are no longer required to support
rsync. This way all parties are freed of direct operational dependencies on
rsync.

# Rsync URIs as object identifiers

[@!RFC6481] defines a profile for the Resource Certificate Repository Structure.
In this profile objects are identified through rsync URIs. E.g. a CA certificate
has an Subject Information Access descriptor which uses an rsync URI to identify
its manifest [@!RFC6486]. The manifest enumerates the relative names and hashes,
for all objects published under the private key of the CA certificate. This the
full rsync URI identifiers for each object can be resolved relative to the
manifest URI.

Though it would be possible in principle to build up an RPKI tree hierarchy of
objects based on key identifiers and hashes [@!RFC8488], most Relying Party
implementations have found it very useful to use rsync URIs for this purpose.
Furthermore, these identifiers make it much easier to name object in case of
validation problems, which help operators to address issues.

For these reasons, RRDP still includes rsync URIs in the definition of the publish,
update and withdraw elements in the snapshot and delta files that it uses. See
section 3.5 of [@!RFC8182]. Thus, objects retrieved through RRDP can be mapped
easily to files and URIs, similar to as though rsync would have been used to
retrieve them.

# Updates to RFC6481

OLD:

- The publication repository SHOULD be hosted on a highly
  available service and high-capacity publication platform.
- The publication repository MUST be available using rsync
  [@!RFC5781] [RSYNC]. Support of additional retrieval mechanisms
  is the choice of the repository operator.  The supported
  retrieval mechanisms MUST be consistent with the accessMethod
  element value(s) specified in the SIA of the associated CA or
  EE certificate.

NEW:

- The publication repository MUST be available using the RPKI
  Repository Delta Protocol [@!RFC8182]. The RRDP server SHOULD
  be hosted on a highly available platform.
- The publication repository MAY be available using rsync [@!RFC5781].
- Support of additional retrieval mechanisms is the choice of the repository
  operator. The supported retrieval mechanisms MUST be consistent with the
  accessMethod element value(s) specified in the SIA of the associated CA or
  EE certificate.


# Deployment Considerations

Relying Parties can drop support for rsync only when all RPKI repositories
support RRDP.

RPKI repositories can drop support for rsync only when Relying Parties support
RRDP. Even when all actively maintained RP software packages support RRDP, there
will still be old versions of the software in operational use. It is most likely
impossible to find that all deployed software supports RRDP, but since RRDP SHOULD
be used when it is available [section 3.4.1 of @!RFC8182] it will be possible to
measure adoption.


## RRDP support in RPKI Repositories

[This section can be updated during discussion of this document, and may be
removed before possible publication.]

| Repository Implementation | Support for RRDP  |
|---------------------------|-------------------|
| afrinic                   | planned           |
| apnic                     | yes               |
| arin                      | under development |
| lacnic                    | planned           |
| ripe ncc                  | yes               |
| rpki.net                  | yes(1)            |
| krill                     | yes(2)            |

(1) in use at various National Internet Registries, as well as other resource
    holders under RIRs.
(2) Software under development.

## RRDP support in Relying Party software

[This section can be updated during discussion of this document, and may be
removed before possible publication.]

| Relying Party Implementation | Support for RRDP  |
|------------------------------|-------------------|
| FORT                         | no                |
| OctoRPKI                     | yes               |
| rcynic                       | yes               |
| RIPE NCC RPKI Validator 2.x  | yes               |
| RIPE NCC RPKI Validator 3.x  | yes               |
| Routinator                   | yes               |
| rpki-client                  | no                |
| RPSTIR                       | yes               |


# IANA Considerations

This document has no IANA actions.

# Security Considerations

TBD

# Acknowledgements

TBD


{backmatter}
