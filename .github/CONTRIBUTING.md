# How to contribute

## Background

### Branches and pull requests

To make a contribution:

1. create a new branch for a given set of logical changes

2. open a pull request for the main branch

3. request a review
    1. click Reviewers from the main tab of the PR
    2. select one or more contributors

4. wait for feedback

For more information, see GitHub's documentation on [creating branches](https://help.github.com/articles/creating-and-deleting-branches-within-your-repository) and [pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

### How we handle proposals

We use GitHub to track proposed changes via its [issue tracker](https://github.com/FoveaCentral/google_maps_geocoder/issues) and [pull requests](https://github.com/FoveaCentral/google_maps_geocoder/pulls). Specific changes are proposed using those mechanisms. Issues are assigned to an individual, who works it, and then marks it complete. If there are questions or objections, the conversation area of that issue or pull request is used to resolve it.

### Two-person review

Our policy is that at least 50% of all proposed modifications will be reviewed before release by a person other than the author, to determine if it is a worthwhile modification and free of known issues which would argue against its inclusion.

We achieve this by splitting proposals into two kinds:

1. Low-risk modifications. These modifications are being proposed by people authorized to commit directly, pass all tests, and are unlikely to have problems. These include documentation/text updates and/or updates to existing gems (especially minor updates) where no risks (such as a security risk) have been identified. The project lead can decide whenther any particular modification is low-risk.

2. Other modifications. These other modifications need to be reviewed by someone else or the project lead can decide to accept the modification. Typically this is done by creating a branch and a pull request so that it can be reviewed before accepting it.

### Developer Certificate of Origin (DCO)

All contributions (including pull requests) must agree to the [Developer Certificate of Origin (DCO) version 1.1](https://developercertificate.org). This is a developer's certification that he or she has the right to submit the patch for inclusion into the project.

Simply submitting a contribution implies this agreement, however, please include a `Signed-off-by` tag in the PR (this tag is a conventional way to confirm that you agree to the DCO).

It's not practical to fix old contributions in git, so if one is forgotten, do not try to fix them. We presume that if someone sometimes used a DCO, a commit without a DCO is an accident and the DCO still applies.

## Types of contributions

### **New to open-source?**

Try your hand at one of the small tasks ideal for new or casual contributors that are [up-for-grabs](https://github.com/FoveaCentral/google_maps_geocoder/issues?q=is%3Aissue+is%3Aopen+label%3Aup-for-grabs). Welcome to the community!

### **Did you find a bug?**

1. **Ensure the bug was not already reported** by searching on GitHub under [Issues](https://github.com/FoveaCentral/google_maps_geocoder/issues).

2. If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/FoveaCentral/google_maps_geocoder/issues/new/choose). Be sure to include:
    1. a **title and clear description**
    2. as much **relevant information** as possible
    3. a **code sample** or an **executable test case** demonstrating the expected behavior that is not occurring.

### **Did you write a patch that fixes a bug or adds a new feature?**

1. **Add specs** that either *reproduce the bug* or *cover the new feature*. In the former's case, *make sure it fails without the fix!*

2. **Confirm your last build passes** on your GitHub branch or PR.

3. **Update the inline documentation.** Format it with [YARD](https://www.rubydoc.info/gems/yard/file/docs/GettingStarted.md). For example, see [`GoogleMapsGeocoder.new`](../lib/google_maps_geocoder.rb).

4. [Open a pull request](https://github.com/FoveaCentral/google_maps_geocoder/compare) with the patch or feature. Follow the template's directions.

## Thanks for contributing!
