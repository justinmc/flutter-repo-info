enum PRStatus {
  open,
  draft,
  merged,
  closed,
}

class PR {
  const PR({
    required this.branch,
    required this.number,
    required this.state,
    required this.htmlURL,
    this.mergeCommitSHA,
    this.mergedAt,
  });

  PR.fromJSON(
    Map<String, dynamic> jsonMap,
  ) : mergeCommitSHA = jsonMap['merge_commit_sha'],
      mergedAt = jsonMap['merged_at'],
      branch = jsonMap['base']['ref'],
      number = jsonMap['number'],
      state = jsonMap['state'],
      htmlURL = jsonMap['html_url'];

  final String? mergeCommitSHA;
  final String? mergedAt;
  final String branch;
  final int number;
  final String state;
  final String htmlURL;

  bool get isMerged => mergedAt != null;

  PRStatus get status {
    if (state == 'open') {
      return PRStatus.open;
    }
    if (state == 'draft') {
      return PRStatus.draft;
    }
    if (mergedAt == null) {
      return PRStatus.closed;
    }
    return PRStatus.merged;
  }

  @override
  String toString() {
    return 'PR {number: $number, mergeCommitSHA: $mergeCommitSHA, mergedAt: $mergedAt, branch: $branch, htmlURL: $htmlURL}';
  }
}