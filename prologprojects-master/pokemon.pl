% Salih Can Ozcelik
% 2016400207
% yes
% yes

:- [pokemon_data].

% find_pokemon_evolution(+PokemonLevel, +Pokemon, -EvolvedPokemon)
find_pokemon_evolution(PokemonLevel,Pokemon,EvolvedPokemon) :- %finds EvolvedPokemon recursively.
	pokemon_evolution(Pokemon,Ara,MinRequiredLevel1),
	MinRequiredLevel1 =< PokemonLevel ->
		find_pokemon_evolution(PokemonLevel,Ara,EvolvedPokemon);
		EvolvedPokemon = Pokemon.

% pokemon_level_stats(+PokemonLevel, ?Pokemon, ?PokemonHp, -PokemonAttack, -PokemonDefense)
pokemon_level_stats(PokemonLevel, Pokemon, PokemonHp, PokemonAttack, PokemonDefense):-  %finds stats according to PokemonLevel
	pokemon_stats(Pokemon,_,HealthPoint,Attack,Defense),
	PokemonHp is HealthPoint+2*PokemonLevel,
	PokemonAttack is Attack+PokemonLevel,
	PokemonDefense is Defense+PokemonLevel.

% single_type_multiplier(?AttackerType, ?DefenderType, ?Multiplier)
single_type_multiplier(AttackerType, DefenderType, Multiplier):- %finds advantages/disadvantages single-type multiplier
	pokemon_types(Type1),
	type_chart_attack(AttackerType,Type2),
	helper1(AttackerType,DefenderType,Type1,Type2,Multiplier).

helper1(AttackerType,DefenderType,[Head1|Tail1],[Head2|Tail2],Multiplier):- %recursively finds multiplier if given types
	DefenderType = Head1,													%matches on the single_type_multiplier
	Multiplier is Head2;
	helper1(AttackerType,DefenderType,Tail1,Tail2,Multiplier).

% type_multiplier(?AttackerType, +DefenderTypeList, ?Multiplier)
type_multiplier(AttackerType, [A,B], Multiplier):-				%similar with single_type_multiplier but not single type
	single_type_multiplier(AttackerType,A,Multiplier1),
	single_type_multiplier(AttackerType,B,Multiplier2),
	Multiplier is Multiplier1*Multiplier2.
type_multiplier(AttackerType, [A], Multiplier):-				%if DefenderTypeList have 1 element.
	single_type_multiplier(AttackerType,A,Multiplier).
type_multiplier(AttackerType, A, Multiplier):-					%if DefenderTypeList have 1 element.
	single_type_multiplier(AttackerType,A,Multiplier).
	
% pokemon_type_multiplier(?AttackerPokemon, ?DefenderPokemon, ?Multiplier)	
pokemon_type_multiplier(AttackerPokemon,DefenderPokemon,Multiplier):-     %finds type multiplier between two Pokemon
	pokemon_stats(AttackerPokemon,AttackType,_,_,_),					  %
	AttackType = [Attack1|Attack2],										  %takes two of the AttackType	
	Attack2 = [Attac2|_],
	pokemon_stats(DefenderPokemon,DefendType,_,_,_),
	type_multiplier(Attack1,DefendType,Mul1),
	type_multiplier(Attac2,DefendType,Mul2),
	max(Mul1,Mul2,Multiplier);											  %find maximum of Mul1 and Mul2
	pokemon_stats(AttackerPokemon,[AttackerType],_,_,_),
	pokemon_stats(DefenderPokemon,DefendType,_,_,_),
	type_multiplier(AttackerType,DefendType,Multiplier).

max(X,Y,Z):-		%used in pokemon_type_multiplier, finds max of X and Y returns to the Z.
	X =< Y,
	Z is Y;
	Y < X,
	Z is X.

%pokemon_level_stats(+PokemonLevel, ?Pokemon, ?PokemonHp, -PokemonAttack, -PokemonDefense)	
%pokemon_attack(+AttackerPokemon, +AttackerPokemonLevel, +DefenderPokemon,+DefenderPokemonLevel, -Damage)
pokemon_attack(AttackerPokemon,AttackerPokemonLevel,DefenderPokemon,DefenderPokemonLevel,Damage):-%finds the damage dealt from the attack of the AttackerPokemon to the DefenderPokemon. 
	pokemon_level_stats(DefenderPokemonLevel,DefenderPokemon,_,_,DefenderPokemonDefense),
	pokemon_level_stats(AttackerPokemonLevel,AttackerPokemon,_,AttackerPokemonAttack,_),
	pokemon_type_multiplier(AttackerPokemon,DefenderPokemon,TypeMultiplier),   
	Damage is ((1/2)*AttackerPokemonLevel*(AttackerPokemonAttack/DefenderPokemonDefense)*TypeMultiplier)+1.

%pokemon_fight(+Pokemon1, +Pokemon1Level, +Pokemon2, +Pokemon2Level,-Pokemon1Hp, -Pokemon2Hp, -Rounds)	
pokemon_fight(Pokemon1,Pokemon1Level,Pokemon2,Pokemon2Level,Pokemon1Hp,Pokemon2Hp,Rounds):-%not enough variable to find rounds and healths.
	pokemon_attack(Pokemon1,Pokemon1Level,Pokemon2,Pokemon2Level,Damage1),			
	pokemon_attack(Pokemon2,Pokemon2Level,Pokemon1,Pokemon1Level,Damage2),
	pokemon_level_stats(Pokemon1Level,Pokemon1,Pokemon1HpA,_,_),
	pokemon_level_stats(Pokemon2Level,Pokemon2,Pokemon2HpA,_,_),
	helper2(Pokemon1HpA,Pokemon2HpA,Pokemon1Hp,Pokemon2Hp,Damage1,Damage2,Rounds).   %thus uses helper predicate

helper2(Pokemon1Hp,Pokemon2Hp,Pokemon1HpDEN,Pokemon2HpDEN,Damage1,Damage2,Rounds):- %finds healths recursively
	(Pokemon1Hp=<0;Pokemon2Hp=<0)->				% if statement
	Rounds is 0,Pokemon2HpDEN is Pokemon2Hp,Pokemon1HpDEN is Pokemon1Hp;
	Pokemon1HpT is Pokemon1Hp-Damage2,
	Pokemon2HpT is Pokemon2Hp-Damage1,
	helper2(Pokemon1HpT,Pokemon2HpT,Pokemon1HpDEN,Pokemon2HpDEN,Damage1,Damage2,Round),
	Rounds is Round+1.							

%pokemon tournament(+PokemonTrainer1, +PokemonTrainer2, -WinnerTrainerList)
pokemon_tournament(PokemonTrainer1, PokemonTrainer2, WinnerTrainerList):-  %finds winner of the tournament
	pokemon_trainer(PokemonTrainer1,PokeList1,PokeLevelList1),
	pokemon_trainer(PokemonTrainer2,PokeList2,PokeLevelList2),
	evolutor(PokeList1,PokeLevelList1,PokeEvolvedList1),				%evolve the Pokemons
	evolutor(PokeList2,PokeLevelList2,PokeEvolvedList2),
	helper3(PokeEvolvedList1,PokeEvolvedList2,PokeLevelList1,PokeLevelList2,WinnerTrainerList,PokemonTrainer1,PokemonTrainer2).

evolutor([],[],[]).											%if list is empty
evolutor([Poke|Pikas],[Level|Leva],[EvolvedPoke|EvolvedPikas]):-  %evolves recursively
	find_pokemon_evolution(Level,Poke,EvolvedPoke),
	evolutor(Pikas,Leva,EvolvedPikas).

helper3([],[],[],[],[],_,_).				%if list is empty
helper3([Head1|Tail1],[Head2|Tail2],[Level1|Leve1],[Level2|Leve2],[Winner|Winne],PokemonTrainer1,PokemonTrainer2):- %works recursively
	pokemon_fight(Head1,Level1,Head2,Level2,Health1,Health2,_),
	(Health2 =< Health1 ->
	Winner = PokemonTrainer1;
	Winner = PokemonTrainer2),
	helper3(Tail1,Tail2,Leve1,Leve2,Winne,PokemonTrainer1,PokemonTrainer2).

%best pokemon(+EnemyPokemon, +LevelCap, -RemainingHP, -BestPokemon)
best_pokemon(EnemyPokemon, LevelCap, RemainingHP, BestPokemon):-	%finds best pokemon to the EnemyPokemon
	findall(X,pokemon_stats(X,_,_,_,_),BetterPokemon),
	helper4(EnemyPokemon,LevelCap,BetterPokemon,RemainingHP,BestPokemon).

helper4(EnemyPokemon,LevelCap,[Better|Bette],RemainingHP,BestPokemon):-
	Bette = [] -> 			%if BetterPokemon have one element
	BestPokemon = Better,pokemon_fight(EnemyPokemon,LevelCap,Better,LevelCap,_,BetterPokemonHp,_), RemainingHP is  BetterPokemonHp;
	pokemon_fight(EnemyPokemon,LevelCap,Better,LevelCap,_,BetterPokemonHp,_),
	helper4(EnemyPokemon,LevelCap,Bette,RemainingHP1,BestPokemon1),
	(BetterPokemonHp>RemainingHP1 ->
	RemainingHP is BetterPokemonHp, BestPokemon = Better;
	RemainingHP is RemainingHP1, BestPokemon = BestPokemon1).

% best pokemon team(+OpponentTrainer, -PokemonTeam)
best_pokemon_team(OpponentTrainer, PokemonTeam):-
	pokemon_trainer(OpponentTrainer,PikaList,Pikalevels),
	helper5(PikaList,Pikalevels,PokemonTeam).

helper5([],[],[]).		%if lists are empty.
helper5([Pika1|Pika2],[PikaLvl1|PikaLvl2],[Team1|Team2]):-
	best_pokemon(Pika1,PikaLvl1,_,BestPika),
	Team1 = BestPika,			%adds the best opponent to PokemonTeam list.
	helper5(Pika2,PikaLvl2,Team2).

pokemon_types(TypeList, InitialPokemonList,PokemonList):-  %I used PS notes in this predicate.
	findall(Pokemon,(member(Pokemon,InitialPokemonList),pokemon_types_2(TypeList,Pokemon)),PokemonList).
pokemon_types_2([H|TypeListTail],Pokemon):-
	pokemon_stats(Pokemon,PokemonTypeList,_,_,_),
	((member(H,PokemonTypeList),!); pokemon_types_2(TypeListTail,Pokemon)).

%generate pokemon team(+LikedTypes, +DislikedTypes, +Criterion, +Count,-PokemonTeam)	
generate_pokemon_team(LikedTypes,DislikedTypes,Criterion,Count,PokemonTeam):-
	findall(X,pokemon_stats(X,_,_,_,_),Pokes),
	pokemon_types(LikedTypes,Pokes,Likeable),			%Liked Pokemons are on Likeable
	pokemon_types(DislikedTypes,Likeable,Dislikeable),	%Disliked Pokemons are on Dislikeable
	subtract(Likeable,Dislikeable,Final),				%Final is Liked - Disliked
	(Criterion=a ->	isA(Final,Temp); 
	(Criterion=h -> isH(Final,Temp);
	isD(Final,Temp))),
	sort(0,>=,Temp,PokemonTeamSorted),
	counterPokemon(Count,PokemonTeamSorted,_,PokemonTeam).

isH([],[]).
isH([FinalE|Fina], [TempH|TempT]):-				%If Criterion is h
	pokemon_stats(FinalE,_,H,_,_),
	TempH = [H,FinalE],
	isH(Fina,TempT).

isA([],[]).										%If Criterion is a
isA([FinalE|Fina], [TempH|TempT]):-
	pokemon_stats(FinalE,_,_,A,_),
	TempH = [A,FinalE],
	isA(Fina,TempT).

isD([],[]).
isD([FinalE|Fina], [TempH|TempT]):-				%If Criterion is d
	pokemon_stats(FinalE,_,_,_,D),
	TempH = [D,FinalE],
	isD(Fina,TempT).

counterPokemon(0,_,_,[]).						%when counter is 0 predicate stops.
counterPokemon(Count,[SortedPokemons|SortedPokemon],[Temp|Tem],[PokemonTeam|PokemonTea]):-
	[_,Temp] = SortedPokemons,		%Takes the PokemonTeamSorted's second type.
	pokemon_stats(Temp,_,H,A,D),	
	PokemonTeam = [Temp,H,A,D],
	Counter is Count - 1,
	counterPokemon(Counter,SortedPokemon,Tem,PokemonTea).
