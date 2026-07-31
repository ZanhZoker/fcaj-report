---
title: "Session Policies in Amazon EKS Pod Identity"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# SESSION POLICIES IN AMAZON EKS POD IDENTITY

Amazon EKS Pod Identity recently added session policies, allowing you to narrow IAM permissions flexibly per pod without creating multiple separate IAM roles.

## Key Points

- **Session policy** is an inline IAM policy specified when creating a Pod Identity association
- **Effective permissions** = intersection between IAM role permissions and session policy → can only narrow, not expand
- Reduces the number of IAM roles to manage, avoiding quota limits
- Supports same-account and cross-account

## AccessDenied Even with Allow?

When encountering AccessDenied, identify 4 elements:

1. **Principal** – who is calling?
2. **Action** – what action?
3. **Resource** – which resource?
4. **Context** – what conditions (region, account, tag, network, session)?

## Policy Layers

| Policy Type          | Grants Permissions | Restricts |
| -------------------- | ------------------ | --------- |
| Identity-based       | ✅                 | ❌        |
| Resource-based       | ✅                 | ❌        |
| Permissions Boundary | ❌                 | ✅        |
| SCP                  | ❌                 | ✅        |
| **Session Policy**   | ❌                 | ✅        |

## AccessDenied Debug Process

1. **Identify caller**: `aws sts get-caller-identity`
2. **Document request**: principal, action, resource, context
3. **Check granting policies**: identity-based, resource-based, trust policy
4. **Check restrictive layers**: boundary, SCP, **session policy**, conditions
5. **Use CloudTrail** and Policy Simulator (has limitations)
6. **Fix the right layer**, test again, narrow permissions

## Common Misunderstandings

- ❌ "An Allow is enough" → Not if boundary/SCP/session policy blocks
- ❌ "SCP grants permissions" → SCP only sets limits
- ❌ "Policy Simulator says allowed = guaranteed" → Has limitations
- ❌ "Broader permissions are faster fix" → Hides root cause, creates risk

## Conclusion

When facing AccessDenied, ask: _"What is the effective permission for this principal, action, resource, and specific context?"_

Session policies provide precise control in EKS, but understanding how IAM layers interact is still essential.

**Original post:** [Facebook AWS Study Group FCJ](https://www.facebook.com/groups/awsstudygroupfcj/?multi_permalinks=2221829758581984)
