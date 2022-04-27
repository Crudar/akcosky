part of 'voting_cubit.dart';

abstract class VotingState extends Equatable {
  const VotingState();
}

class VotingInitial extends VotingState {
  @override
  List<Object> get props => [];
}

class VotingUnvoted extends VotingState{
  @override
  List<Object> get props => [];
}

class VotingAlreadyVoted extends VotingState{
  @override
  List<Object> get props => [];
}

class VotingSuccessfullVote extends VotingState{
  final Vote newVote;

  VotingSuccessfullVote(this.newVote);
  @override
  List<Object> get props => [this.newVote];
}

class VotingStatusMessage extends VotingState{
  final String message;

  const VotingStatusMessage(this.message);
  @override
  List<Object> get props => [this.message];
}

class VotingError extends VotingState{
  final String message;

  const VotingError(this.message);
  @override
  List<Object> get props => [this.message];
}

class VotingReload extends VotingState{
  @override
  List<Object> get props => [];
}