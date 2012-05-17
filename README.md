NLP-CCG
=======

Really liked the NLP lecture on CCG. Implemented each word in Haskell so if you write a sentence with those words you end up with a sentence program, which when run gives you all the relationships between the words in the sentence.


    t0 = ((_John `_eat`) `_and` (_Mary `_eat`)) (_red _apple)
    t1 = ((_John `_eat`) `_and` (_Mary `_drink`)) ((_red _apple) `_and` _water)
    t2 = ((_I `_like`) `_and` (_Mary `_hates`)) _apples
    t3 = (_Yahoo `_bought` _IBM) `_but` (_Microsoft `_sold` _Apple)
    t4 = _John `_said` (_Mary `_bought` _apples)
    t5 = _John `_said` (_Steve `_said` (_Mary `_bought` _apples))
    t6 = _John `_ate` (_pizza `_with` _apples)
    t7 =_John \\ ((`_ate` _pizza) `_with` ((_a _fork) `_and` (_a _water)))
    t8 = (_John `_ate` _pizza) `_with` (_Mary `_and` _Steve)


    $ ghci
    GHCi, version 7.0.3: http://www.haskell.org/ghc/  :? for help
    Loading package ghc-prim ... linking ... done.
    Loading package integer-gmp ... linking ... done.
    Loading package base ... linking ... done.
    Loading package ffi-1.0 ... linking ... done.
    Prelude> :l CCG.hs
    [1 of 1] Compiling Main             ( CCG.hs, interpreted )

    CCG.hs:78:10:
        Warning: No explicit method nor default method for `append'
        In the instance declaration for `Nom S'
    Ok, modules loaded: Main.
    *Main> t0
    S [Rel [Event "eat",Agent (Object "John"),Patient (Rel [Object "apple",Object "(red)"])],Rel [Event "eat",Agent (Object "Mary"),Patient (Rel [Object "apple",Object "(red)"])]]
    *Main> t1
    S [Rel [Event "eat",Agent (Object "John"),Patient (Rel [Object "apple",Object "(red)"])],Rel [Event "eat",Agent (Object "John"),Patient (Object "water")],Rel [Event "drink",Agent (Object "Mary"),Patient (Rel [Object "apple",Object "(red)"])],Rel [Event "drink",Agent (Object "Mary"),Patient (Object "water")]]
    *Main> t2
    S [Rel [Event "like",Agent (Object "I"),Patient (Object "apples")],Rel [Event "hates",Agent (Object "Mary"),Patient (Object "apples")]]
    *Main> t3
    S [Rel [Event "bought",Agent (Object "Yahoo"),Patient (Object "IBM")],Rel [Event "sold",Agent (Object "Microsoft"),Patient (Object "Apple")]]
    *Main> t4
    S [Rel [Event "said",Agent (Object "John"),Patient (Prp (S [Rel [Event "bought",Agent (Object "Mary"),Patient (Object "apples")]]))]]
    *Main> t5
    S [Rel [Event "said",Agent (Object "John"),Patient (Prp (S [Rel [Event "said",Agent (Object "Steve"),Patient (Prp (S [Rel [Event "bought",Agent (Object "Mary"),Patient (Object "apples")]]))]]))]]
    *Main> t6
    S [Rel [Event "ate",Agent (Object "John"),Patient (With [Rel [Object "pizza"],Rel [Object "apples"]])]]
    *Main> t7
    S [With [Rel [Event "ate",Agent (Object "John"),Patient (Object "pizza")],Object "fork"],With [Rel [Event "ate",Agent (Object "John"),Patient (Object "pizza")],Object "water"]]
    *Main> t8
    S [With [Rel [Event "ate",Agent (Object "John"),Patient (Object "pizza")],Object "Mary"],With [Rel [Event "ate",Agent (Object "John"),Patient (Object "pizza")],Object "Steve"]]