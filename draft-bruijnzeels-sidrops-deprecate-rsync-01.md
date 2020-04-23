%%%
Title = "Resource Public Key Infrastructure (RPKI) Repository Requirements"
category = "std"
docName = "draft-sidrops-bruijnzeels-deprecate-rsync-01"
abbrev = "RPKI Repository Requirements"
ipr = "trust200902"
updates = [6841, 8182]

[[author]]
initials="T."
surname="Bruijnzeels"
fullname="Tim Bruijnzeels"
organization = "NLnet Labs"
  [author.address]
  email = "tim@nlnetlabs.nl"
  uri = "https://www.nlnetlabs.nl/"

[[author]]
initials="R."
surname="Bush"
fullname="Randy Bush"
organization = "Internet Initiative Japan & Arrcus, Inc."
  [author.address]
  email = "randy@psg.com"

[[author]]
initials="G."
surname="Michaelson"
fullname="George Michaelson"
organization = "APNIC"
  [author.address]
  email = "ggm@apnic.net"
  uri = "http://www.apnic.net"

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

This document requires that:
- All RPKI repositories support RRDP as a highly available service
- Relying Parties support and prefer RRDP over rsync
- RPKI repositories support rsync for debugging purposes only

This way all parties are freed of direct operational dependencies on
rsync.


# Updates to RFC 6481

This document updates [section 3 of @!RFC6481].

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
- The publication repository SHOULD be available using rsync
  [@!RFC5781] to support easy direct access to RPKI objects for
  debugging purposes. However, it no longer required that the rsync
  repository is hosted on a highly available service and high-capacity
  publication platform.
- Support of additional retrieval mechanisms is the choice of the repository
  operator. The supported retrieval mechanisms MUST be consistent with the
  accessMethod element value(s) specified in the SIA of the associated CA or
  EE certificate.

# Updates to RFC 8182

This document updates [section 3.4.1 of @!RFC8182].

OLD:
  When a Relying Party performs RPKI validation and learns about a
  valid certificate with an SIA entry for the RRDP protocol, it SHOULD
  use this protocol as follows.

NEW:
  When a Relying Party performs RPKI validation and learns about a
  valid certificate with an SIA entry for the RRDP protocol, it MUST
  use this protocol. It MUST NOT depend on object retrieval for this
  certificate over rsync for validation, although it MAY still use
  rsync access for other purposes under the understanding that availability
  is not guaranteed.

# Rsync URIs as object identifiers

[@!RFC6481] defines a profile for the Resource Certificate Repository Structure.
In this profile objects are identified through rsync URIs. E.g. a CA certificate
has an Subject Information Access descriptor which uses an rsync URI to identify
its manifest [@!RFC6486]. The manifest enumerates the relative names and hashes
for all objects published under the private key of the CA certificate. The full
rsync URI identifiers for each object can be resolved relative to the manifest
URI.

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

Even though objects are no longer guaranteed to be available over rsync, we
still use rsync as the mandatory scheme in the CRL Distribution Points, Authority
Information Access, and Subject Information Access defined in [@!RFC6487].
Changing this would introduce breaking changes which make deployment very hard
indeed: we would need to invent an alternative naming scheme, which would need
to be supported by all Relying Parties, before Certification Authorities can
issue any certificate or RPKI signed objects using these schemes.

Furthermore, it is very convenient to have direct access to RPKI objects using
rsync for troubleshooting, debugging and research purposes.

# Deployment Phases

We recognise the following phases:

## Phase 0 - RPKI repositories support rsync, and optionally RRDP

This is the situation at the time of writing this document. Relying Parties can
prefer RRDP over rsync today, but they need to support rsync until all RPKI
repositories support RRDP. Therefore all repositories should support RRDP at
their earliest convenience.

## Phase 1 - RPKI repositories support both rsync and RRDP

Once all repositories support RRDP, all Relying Party software should start to
prefer it over rsync.

## Phase 2 - All RP software prefers RRDP

Although the tools may support RRDP, users will still need to install updated
versions of these tools in their infrastructure. Therefore it is expected that
there will be long tail of users who still depend on rsync to be highly
available.

Measurements can help to determine the shape of this tail and can then help to
inform the technical community of when it would be safe to move to the next
phase.

## Phase 3 - No operational dependencies on rsync

During this phase RPKI repositories will no longer be required to support rsync
as a highly available service.

# Current State of RRDP Deployment

[This section can be updated during discussion of this document, and may be
removed before possible publication.]

## RRDP support in RPKI Repositories

| Repository Implementation | Support for RRDP  |
|---------------------------|-------------------|
| afrinic                   | yes               |
| apnic                     | yes               |
| arin                      | yes               |
| lacnic                    | planned           |
| ripe ncc                  | yes               |
| Dragon Research Labs      | yes(1)            |
| krill                     | yes(1)            |

(1) in use at various National Internet Registries, as well as other resource
    holders under RIRs.

## RRDP support in Relying Party software

| Relying Party Implementation | RRDP | version | since    |
|------------------------------|------|---------|----------|
| FORT                         | yes  |       ? |     ?    |
| OctoRPKI                     | yes  |       ? |     ?    |
| rcynic                       | yes  |       ? |     ?    |
| RIPE NCC RPKI Validator 2.x  | yes  |       ? |     ?    |
| RIPE NCC RPKI Validator 3.x  | yes  |       ? |     ?    |
| Routinator                   | yes  |   0.6.0 | Sep 2019 |
| rpki-client                  | no   |       ? |     ?    |
| RPSTIR                       | yes  |       ? |     ?    |

The authors kindly request Relying Party software implementers to let us know
in which version of their tool support for RRDP was introduced, and when that
version was released.

# IANA Considerations

This document has no IANA actions.

# Security Considerations

TBD

# Acknowledgements

TBD


{backmatter}
