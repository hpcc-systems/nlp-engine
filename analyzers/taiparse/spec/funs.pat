###############################################
# COPYRIGHT (c) 2020 by Conceptual Systems, LLC.
# COPYRIGHT (c) 2008-14 by Text Analysis International, Inc.
# All rights reserved.
#
# FILE: funs.pat
# SUBJ: Miscellaneous functions.
# AUTH: AM
# CREATED: 06/Jul/04 02:00:25
# MODIFIED:	12/13/20 AM.
###############################################

@DECL
########
# FUNC:   LOOKUPALPHADICTTOKZ
# SUBJ:   Look up an alphabetic word (with DICTTOKZ tokenize pass).
# CR:     03/30/20 AM.
# INPUT:  Assumes there's a word-node to attach results to.
# OUTPUT: 
# WARN:   Modifies vars in the given node.
# ERROR:	DICTTOKZ neglects to put the "POS" attribute on
#	nodes.	# [BUG, FEATURE, OMISSION, OVERSIGHT]	# 03/30/20 AM.
########

lookupalphadicttokz(
	L("text"),	# Lowercased text for word.
	L("node")	# The node representing the word.
	)
{
if (!(L("wordcon") = dictfindword(L("text"))))
	return;	# Not handling unknown words here.
pnreplaceval(L("node"),"wordcon", L("wordcon"));

# Grab some attributes from kb.	# 06/24/02 AM.
if (L("nsem") = conval(L("wordcon"),"nounsem"))	# 06/24/02 AM.
  {
  pnreplaceval(L("node"),"nounsem",L("nsem"));	# 06/24/02 AM.
  if (inhierarchy(L("nsem"),"event"))	# 06/26/02 AM.
      pnreplaceval(L("node"),"eventive",1);	# 06/24/02 AM.
  pnreplaceval(L("node"),"sem",conceptname(L("nsem")));
  }
#domobject(L("text"),L("node"),L("nsem"));

L("pos num") = pnvar(L("node"),"pos num");

if (L("pos num") > 0 && !pnvar(L("node"),"stem"))	# [MOVED_UP]	# 12/29/20 AM.
  {
  if (L("stem") = nvstem(L("text")))
  	pnreplaceval(L("node"),"stem",L("stem"));
  else
    pnreplaceval(L("node"),"stem",L("text"));
  }

#L("pos") = 0;
if (L("pos num") == 1)
	{
    if (pnvar(L("node"),"noun")) { pnreplaceval(L("node"),"pos","_noun"); return; }
	if (pnvar(L("node"),"verb"))
		{
		pnreplaceval(L("node"),"pos","_verb");
		
		# Any -ing verb can be an eventive noun.
		if (strendswith(L("text"),"ing"))
			pnreplaceval(L("node"),"eventive",1);
		return;
		}
	####### [REWORK]	# 12/29/20 AM.
	# TODO:	NORMALIZE THESE IN THE KB DICTIONARY AND IN ANALYZERS.
	if (pnvar(L("node"),"adj"))			{ pnreplaceval(L("node"),"pos","_adj"); chpos(L("node"),"JJ"); return; }
	if (pnvar(L("node"),"adv"))			{ pnreplaceval(L("node"),"pos","_adv"); chpos(L("node"),"RB"); return; }
	if (pnvar(L("node"),"prep"))		{ pnreplaceval(L("node"),"pos","_prep"); chpos(L("node"),"IN"); return; }
	if (pnvar(L("node"),"pro"))			{ pnreplaceval(L("node"),"pos","_pro"); chpos(L("node"),"PRP"); return; }
	if (pnvar(L("node"),"conj")) 		{ pnreplaceval(L("node"),"pos","_conj"); chpos(L("node"),"CC"); return; }
	if (pnvar(L("node"),"det"))			{ pnreplaceval(L("node"),"pos","_det"); chpos(L("node"),"DT"); return; }
	if (pnvar(L("node"),"interj"))		{ pnreplaceval(L("node"),"pos","_interj"); chpos(L("node"),"UH"); return; }
	# TODO: SHORTEN THESE IN KB DICT.
	if (pnvar(L("node"),"adjective"))	{ pnreplaceval(L("node"),"pos","_adj"); chpos(L("node"),"JJ"); return; }
	if (pnvar(L("node"),"adverb"))		{ pnreplaceval(L("node"),"pos","_adv"); chpos(L("node"),"RB"); return; }
	if (pnvar(L("node"),"pronoun"))		{ pnreplaceval(L("node"),"pos","_pro"); chpos(L("node"),"PRP"); return; }
	if (pnvar(L("node"),"conjunction")) { pnreplaceval(L("node"),"pos","_conj");	# FIX.	# 12/29/20 AM.
																				chpos(L("node"),"CC"); return; }
	if (pnvar(L("node"),"interjection"))	{ pnreplaceval(L("node"),"pos","_interj"); chpos(L("node"),"UH"); return; }
		####### [REWORK]	# 12/29/20 AM.

#	else
#	    {
		# Hmm.  Found "abbreviation" as one unhandled
		# pos.  # 12/08/01 AM.
#		"misc.txt" << "abbreviation=" << L("text") << "\n";
#		pnreplaceval(L("node"),"abbr",1);
		# L("pos") = 0;
#		}
	}

}


########
# FUNC:   LOOKUPALPHA
# SUBJ:   Look up an alphabetic word.
# CR:     03/20/02 AM.
# INPUT:  Assumes there's a word-node to attach results to.
# OUTPUT: 
# WARN:   Modifies vars in the given node.
# ERROR:	DICTTOKZ neglects to put the "POS" attribute on
#	nodes.	# 03/30/20 AM.
########

lookupalpha(
	L("text"),	# Lowercased text for word.
	L("node")	# The node representing the word.
	)
{
if (!(L("wordcon") = dictfindword(L("text"))))
	return;	# Not handling unknown words here.
pnreplaceval(L("node"),"wordcon", L("wordcon"));

# Grab some attributes from kb.	# 06/24/02 AM.
if (L("nsem") = conval(L("wordcon"),"nounsem"))	# 06/24/02 AM.
  {
  pnreplaceval(L("node"),"nounsem",L("nsem"));	# 06/24/02 AM.
  if (inhierarchy(L("nsem"),"event"))	# 06/26/02 AM.
      pnreplaceval(L("node"),"eventive",1);	# 06/24/02 AM.
  pnreplaceval(L("node"),"sem",conceptname(L("nsem")));
  }
#domobject(L("text"),L("node"),L("nsem"));

L("vals") = findvals(L("wordcon"), "pos");
L("pos num") = 0;
L("pos") = 0;
while (L("vals"))
	{
	L("val") = getstrval(L("vals"));
	if (L("val") == "noun")
		{
		pnreplaceval(L("node"),"noun", 1);
		L("pos") = "_noun";
#		eventivenoun(L("text"),L("node"));
		}
	else if (L("val") == "verb")
		{
		pnreplaceval(L("node"),"verb", 1);
		L("pos") = "_verb";
		
		# Any -ing verb can be an eventive noun.
		if (strendswith(L("text"),"ing"))
			pnreplaceval(L("node"),"eventive",1);
		}
	else if (L("val") == "adjective")
		{
		pnreplaceval(L("node"),"adj", 1);
		L("pos") = "_adj";
		}
	else if (L("val") == "adverb")
		{
		pnreplaceval(L("node"),"adv", 1);
		L("pos") = "_adv";
		}
	else if (L("val") == "prep")
		{
		pnreplaceval(L("node"),"prep", 1);
		L("pos") = "_prep";
		}
	else if (L("val") == "pronoun")
		{
		pnreplaceval(L("node"),"pro", 1);
		L("pos") = "_pro";
		}
	else if (L("val") == "conj"
	 || L("val") == "conjunction")	# 03/20/02 AM.
		{
		pnreplaceval(L("node"),"conj", 1);
		L("pos") = "_conj";
		}
	else if (L("val") == "interj")
		{
		pnreplaceval(L("node"),"interj", 1);
		L("pos") = "_interj";
		}
	else if (L("val") == "det")
		{
		pnreplaceval(L("node"),"det", 1);
		L("pos") = "_det";
		}
	else
	    {
		# Hmm.  Found "abbreviation" as one unhandled
		# pos.  # 12/08/01 AM.
#		"misc.txt" << "abbreviation=" << L("text") << "\n";
		pnreplaceval(L("node"),"abbr",1);
		# L("pos") = 0;
		}
	L("vals") = nextval(L("vals"));
	++L("pos num");
	}
pnreplaceval(L("node"),"pos num", L("pos num"));

if (L("pos") && !pnvar(L("node"),"pos")) # 06/05/05 AM.
   pnreplaceval(L("node"),"pos",L("pos"));
if (L("pos num") > 0 && !pnvar(L("node"),"stem"))
  {
  if (L("stem") = nvstem(L("text")))
  	pnreplaceval(L("node"),"stem",L("stem"));
  else
    pnreplaceval(L("node"),"stem",L("text"));
  }
}

########
# FUNC:   VGAGREE
# CR:	  05/03/02 AM.
# ARGS:	  Top-level nodes assumed to bear info.
# RET:	  L("ret")[0] - 1 if agreement, else 0.
#		  L("ret")[1] - 1 if passive voice, else 0.
#		  L("ret")[2] - "past", "present", "future", 0.
#		  L("ret")[3] = "inf","-en","-ed","-edn","-ing","-s", or 0. 
#				First element's conjugation. (see notes).
#		  May want progressive, etc. "was eating..."
#	Would like the FAILURE POINT, so that I know where to flag
#	no glomming verbs left and no glomming verbs right.
# NOTE:	For constructs like "Should John be eating", will
#	consider that "be eating" has good agreement.  But
#	may want to return a flag saying it is "incomplete".
#	Should John be eating => inf-start.
#	Has John eaten => en-start.
#	Was John eating => ing-start.
#	Was John eaten => en-start.
# Some hints:
#	modal => needs inf.
#	have  => needs en.
#	be    => needs en (passive) or ing.
#   being => needs en.
# OPT: May want to internalize this in NLP++ for speed, at some
#	point.
########

vgagree(L("m"),L("h"),L("b"),L("being"),L("v"))
{
#if (L("m"))
#  "vg.txt" << "m=" << pnvar(L("m"),"$text") << "\n";
#if (L("v"))
#  "vg.txt" << "v=" << pnvar(L("v"),"$text") << "\n";

L("ret")[0] = 1; # Agreement till proved otherwise.
L("ret")[3] = 0; # Set return vals to zero.

L("need") = 0;	# What's needed next.
	# Vals = "inf","en","en-ing".
L("first") = 0; # First element seen.
L("last") = 0;  # Last element seen.

if (L("m")) # MODAL
  {
  # Need to set can-could type of modality here, or "future".

    L("need") = "inf";
  if (!L("first"))
    L("first") = L("m");
  L("last") = L("m");
  }

if (L("h"))	# HAVE
  {
  if (L("need") == "inf"
   && !pnvar(L("h"),"inf") )
    {
	# eg, "WILL HAD".
	L("ret")[0] = 0;	# NO AGREEMENT.
	return L("ret");
	}

  L("need") = "en";
  if (!L("first"))
    L("first") = L("h");
  L("last") = L("h");
  }

if (L("b"))	# BE
  {
  if (L("need") == "inf")
    {
    if (!pnvar(L("b"),"inf"))
      {
	  # eg, "WILL BEEN".
	  L("ret")[0] = 0;	# NO AGREEMENT.
	  return L("ret");
	  }
	}
  else if (L("need") == "en"  # BUG FIX.	# 07/10/02 AM.
   && !pnvar(L("b"),"-en") )
    {
	# eg, "HAVE ARE".
	L("ret")[0] = 0;	# NO AGREEMENT.
	return L("ret");
	}
  
  L("need") = "en-ing";
  if (!L("first"))
    L("first") = L("b");
  L("last") = L("b");
  }

if (L("being"))	# BEING
  {
  if (L("need") == "inf")
    {
	# eg, "WILL BEING".
	L("ret")[0] = 0;	# NO AGREEMENT.
	return L("ret");
	}
  else if (L("need") == "en")	# BUG FIX.	# 07/10/02 AM.
    {
	# eg, "HAVE BEING".
	L("ret")[0] = 0;	# NO AGREEMENT.
	return L("ret");
	}
  # else 0 or "en-ing" are OK.

  L("need") = "en";
  if (!L("first"))
    L("first") = L("being");
  L("last") = L("being");
  }

if (L("v"))	# VERB
  {
  L("vsuff") = vconj(L("v"));
  if (!L("vsuff"))
      {
	  # eg, "WAS BEEN".
	  L("ret")[0] = 0;	# NO AGREEMENT.
	  return L("ret");
	  }

  if (L("need") == "inf")
    {
	if (!vconjq(L("v"),"inf"))
      {
	  # eg, "WILL ATE".
	  L("ret")[0] = 0;	# NO AGREEMENT.
	  return L("ret");
	  }
	}
  else if (L("need") == "en")	# BUG FIX.	# 07/10/02 AM.
    {
	if (!vconjq(L("v"),"-en"))
      {
	  # eg, "HAVE ATE".
	  L("ret")[0] = 0;	# NO AGREEMENT.
	  return L("ret");
	  }
	}
  else if (L("need") == "en-ing")
    {
    if (L("vsuff") == "-edn"
	 || L("vsuff") == "-en" )
	  {
	  L("ret")[1] = 1;  # SETS PASSIVE VOICE FOR VG.
	  }
	else if (L("vsuff") == "-ing")
	  {
	  }
	else
      {
	  # eg, "WAS ATE".
	  L("ret")[0] = 0;	# NO AGREEMENT.
	  return L("ret");
	  }
	}
  # else 0 is OK.
  
  if (!L("first"))
    L("first") = L("v");
  L("last") = L("v");
  }

# TODO: Use first and last to determine need to the left
# and need to the right of this verb group.  eg, for
# resolving question syntax to left, unknown words to right.

return L("ret");
}

########
# FUNC:	VCONJQ
# SUBJ:	Get needed verb conjugation.
# ARGS:	Verb node.
# RET:	1 if matched need, else 0.
# ASS:	Assumes all irregular verb forms are in (l_)common.pat
#		(Could place this knowledge in kb also, for easy
#		reference...)
# NOTE:	VARIANT OF VCONJ TO HANDLE AMBIGUOUS VERBS LIKE "set".
#	For need == "-edn", requiring exact match. This will enable
#	user to tailor calls more flexibly.
#	If asking for "-edn", get anything that qualifies.
########

vconjq(L("v"), L("need"))
{
if (!L("v") || !L("need"))
  {
  "err.txt" << "vcongj: ";
  "err.txt" << L("need") << "  " << phrasetext();
  "err.txt" << "  " << G("$passnum") << "," << G("$rulenum") << "\n";
  return 0;
  }

if (pnname(L("v")) == "_vg")
  L("v") = pnvar(L("v"),"verb node"); # 05/20/07 AM.
if (!L("v"))
  {
  "err.txt" << "vcongj: ";
  "err.txt" << L("need") << "  " << phrasetext();
  "err.txt" << "  " << G("$passnum") << "," << G("$rulenum") << "\n";
  return 0;
  }

# Exact match.
if (pnvar(L("v"),L("need")))
  return 1;

# OPT: May want to collapse all this to one var!
if (pnvar(L("v"),"-edn"))	# Irregular verb +edn ending.
  {
  if (L("need") == "-en"
   || L("need") == "-ed")
    return 1;
  return 0;	# Assume no match.
  }

if (L("need") == "-edn")
  {
  if (pnvar(L("v"),"-en")
   || pnvar(L("v"),"-ed"))	# Changing to an OR. # 05/28/07 AM.
    return 1;
  }

# If any nonmatching conjugation present, assume failure.
# (Features should be complete, if present.)
if (pnvar(L("v"),"-en"))	# Irregular +en
  return 0;
if (pnvar(L("v"),"inf"))	# Exception like "need".
  return 0;
if (pnvar(L("v"),"-ed"))	# Irregular like "ate".
  return 0;
if (pnvar(L("v"),"-ing"))
  return 0;
if (pnvar(L("v"),"-s"))
  return 0;

# Moved this down here. # 06/03/06 AM.
if (pnvar(L("v"),"stem") == "be") # Special case.
  {
  # Todo: Can now handle all these....
  return 0;
  }

# NOT IRREGULAR, SO USE LITERAL TEXT.
# Need a convention for getting just the verb's text.
# eg in something like "haven't".
L("vtext") = nodetext(L("v"));
#"vg.txt" << "vconj text=" << L("vtext") << "\n";
if (!L("vtext"))
  return 0;
if (strendswith(L("vtext"),"ed"))
  {
  if (L("need") == "-edn"
   || L("need") == "-en"
   || L("need") == "-ed")
    return 1;	# "Normal" verb with ambiguous ed ending.
  return 0;
  }
if (strendswith(L("vtext"),"ing"))
  return L("need") == "-ing";
#if (suffix(L("vtext"),"s"))	# "s" is a proper suffix.
if (nvsuff(L("vtext")) == "-s")	# 06/15/06 AM.
  return L("need") == "-s";
return L("need") == "inf";	# Assume found uninflected form.
}

########
# FUNC:	VCONJ
# SUBJ:	Get verb conjugation.
# ARGS:	Verb node.
# RET:	"inf","-s","-ing","-edn","-ed","-en", or 0.
# ASS:	Assumes all irregular verb forms are in (l_)common.pat
#		(Could place this knowledge in kb also, for easy
#		reference...)
#		May not work as desired for verbs like be.
#		Need to handle highly ambiguous, eg, "set".
########

vconj(L("v"))
{
if (!L("v"))
  return 0;

# OPT: May want to collapse all this to one var!
if (pnvar(L("v"),"-edn"))	# Irregular verb +edn ending.
  return "-edn";
if (pnvar(L("v"),"-en"))	# Irregular +en
  return "-en";
if (pnvar(L("v"),"inf"))	# Exception like "need".
  return "inf";
if (pnvar(L("v"),"-ed"))	# Irregular like "ate".
  return "-ed";
if (pnvar(L("v"),"-ing"))
  return "-ing";
if (pnvar(L("v"),"-s"))
  return "-s";

# Moved this down here. # 06/03/06 AM.
if (pnvar(L("v"),"stem") == "be") # Special case.
  return 0;

# NOT IRREGULAR, SO USE LITERAL TEXT.
# Need a convention for getting just the verb's text.
# eg in something like "haven't".
L("vtext") = nodetext(L("v"));
#"vg.txt" << "vconj text=" << L("vtext") << "\n";
if (!L("vtext"))
  return 0;
if (strendswith(L("vtext"),"ed"))
  return "-edn";	# "Normal" verb with ambiguous ed ending.
if (strendswith(L("vtext"),"ing"))
  return "-ing";
#if (suffix(L("vtext"),"s"))	# "s" is a proper suffix.
if (nvsuff(L("vtext")) == "-s")	# 06/15/06 AM.
  return "-s";
return "inf";	# Assume found uninflected form.
}

##############
## QADDSTR
## SUBJ: Add string to array if unique.
## RET:	New array.
## NOTE:	Assume array of non-empty values.
##############

qaddstr(L("txt"),L("arr"))
{
if (!L("txt"))
  return L("arr");
if (!L("arr"))
  return L("txt");

L("ii") = 0;
while (L("elt") = L("arr")[L("ii")] )
  {
  L("t") = L("arr")[L("ii")];
  if (strequalnocase(L("txt"),L("t")))
    return L("arr");	# String aleady there.
  ++L("ii");
  }
# Didn't find text, so add to end.
L("arr")[L("ii")] = L("txt");
return L("arr");
}

##############
## QADDVALUE
## SUBJ: Add value to array if unique.
## RET:	New array.
## NOTE:	Assume array of non-empty values.
##############

qaddvalue(L("val"),L("arr"))
{
if (!L("val"))
  return L("arr");
if (!L("arr"))
  return L("val");

L("ii") = 0;
while (L("v") = L("arr")[L("ii")] )
  {
  if (L("v") == L("val"))
    return L("arr");	# Value aleady there.
  ++L("ii");
  }
# Didn't find text, so add to end.
L("arr")[L("ii")] = L("val");
return L("arr");
}


##############
## ADDVALUE
## SUBJ: Add value to array, no checking.
## RET:	New array.
## NOTE:	Assume array of non-empty values.
##############

addvalue(L("val"),L("arr"))
{
if (!L("val"))
  return L("arr");
if (!L("arr"))
  return L("val");

L("len") = arraylength(L("arr"));

# Didn't find text, so add to end.
L("arr")[L("len")] = L("val");
return L("arr");
}


##############
## QADDCONVAL
## SUBJ: Add to kb concept list if unique.
## RET:	1 if unique and added, else 0 (redundant or error).
## NOTE:
##############

qaddconval(
	L("con"),	# Concept holding list of cons.
	L("key"),	# Field name holding list.
	L("conval")	# Value to add to list.
	)
{
if (!L("con") || !L("key") || !L("conval"))
  return 0;

if (!(L("val") = findvals(L("con"),L("key")) ))
  {
  # No values, so add new concept to list.
  addconval(L("con"),L("key"),L("conval"));
  return 1;
  }

while (L("val"))
  {
  L("c") = getconval(L("val"));
  # If redundant, done.
  if (L("c") == L("conval")) return 0;
  L("val") = nextval(L("val"));
  }

# Did not find concept in list, so add it.
# NLP++: A way to add concept at end of list.
addconval(L("con"),L("key"),L("conval"));
return 1;
}


##############
## QADDSTRVAL
## SUBJ: Add to kb concept list if unique.
## RET:	1 if unique and added, else 0 (redundant or error).
## NOTE:
##############

qaddstrval(
	L("con"),	# Concept holding list of cons.
	L("key"),	# Field name holding list.
	L("strval")	# Value to add to list.
	)
{
if (!L("con") || !L("key") || !L("strval"))
  return 0;

if (!(L("val") = findvals(L("con"),L("key")) ))
  {
  # No values, so add new concept to list.
  addstrval(L("con"),L("key"),L("strval"));
  return 1;
  }

while (L("val"))
  {
  L("c") = getstrval(L("val"));
  # If redundant, done.
  if (L("c") == L("strval")) return 0;
  L("val") = nextval(L("val"));
  }

# Did not find concept in list, so add it.
# NLP++: A way to add concept at end of list.
addstrval(L("con"),L("key"),L("strval"));
return 1;
}


##############
## NAMEINLIST
## SUBJ: See if name is in given array and count.
## RET:	[0] 1 if present, 0 if absent.
##		[1] Position in list, if present.
##############

nameinlist(L("txt"),L("arr"),L("count"))
{
if (!L("txt") || !L("count"))
  return 0;
L("ii") = 0;
while (L("ii") < L("count"))
  {
  L("t") = L("arr")[L("ii")];
  if (strequalnocase(L("txt"),L("t")))
    {
	L("res")[0] = 1;
	L("res")[1] = L("ii");
    return L("res");
	}
  ++L("ii");
  }
return 0;
}

##############
## SUBNAMEINLIST
## SUBJ: See if name is in (or starts) given array and count.
## RET:	[0] 1 if present, 0 if absent.
##		[1] Position in list, if present.
##############

subnameinlist(L("txt"),L("arr"),L("count"))
{
if (!L("txt") || !L("count"))
  return 0;
L("utxt") = strtoupper(L("txt"));
L("ii") = 0;
while (L("ii") < L("count"))
  {
  L("t") = L("arr")[L("ii")];
  if (strequalnocase(L("txt"),L("t")))
    {
	L("res")[0] = 1;
	L("res")[1] = L("ii");
    return L("res");
	}
  else
    {
	L("ut") = strtoupper(L("t"));
	if (G("dev")) "subname.txt" << L("ut") << " vs " << L("utxt") << "\n";
	if (strstartswith(L("ut"),L("utxt")))
	  {
	  L("res")[0] = 1;
	  L("res")[1] = L("ii");
      return L("res");
	  }
	else if (strstartswith(L("utxt"),L("ut")))
	  {
	  # Todo: May want to update organization name...
	  # Todo: Need a function for looking up org vs indiv.
	  L("res")[0] = 1;
	  L("res")[1] = L("ii");
      return L("res");
	  }
	
	}
  ++L("ii");
  }
return 0;
}

##############
## MINIMUM
## SUBJ: Get minimum of two numbers.
## RET:	Smaller number.
## WARN:	"min" is a C++ function name, and so won't compile.
##############

minimum(L("a"),L("b"))
{
if (L("a") < L("b"))
  return L("a");
return L("b");
}

##############
## MAXIMUM
## SUBJ: Get maximum of two numbers.
## RET:	Larger number.
## WARN:	"max" is a C++ function name, and so won't compile.
##############

maximum(L("a"),L("b"))
{
if (L("a") > L("b"))
  return L("a");
return L("b");
}

##############
## ABSOLUTE
## SUBJ: Get absolute value.
##############

absolute(L("num"))
{
if (L("num") >= 0)
  return L("num");
L("x") = -L("num");
#return -L("num");	# NLP++ error.
return L("x");
}

########
# FUNC:   MONTHTONUM
# SUBJ:   Convert month to number.
# CR:     04/19/02 AM.
# INPUT:  
# OUTPUT: 
########

monthtonum(
	L("text")	# Lowercased text for word.
	)
{
if (L("text") == "january" || L("text") == "jan")
  return 1;
else if (L("text") == "february" || L("text") == "feb")
  return 2;
else if (L("text") == "march" || L("text") == "mar")
  return 3;
else if (L("text") == "april" || L("text") == "apr")
  return 4;
else if (L("text") == "may")
  return 5;
else if (L("text") == "june" || L("text") == "jun")
  return 6;
else if (L("text") == "july" || L("text") == "jul")
  return 7;
else if (L("text") == "august" || L("text") == "aug")
  return 8;
else if (L("text") == "september" || L("text") == "sep"
	|| L("text") == "sept")
  return 9;
else if (L("text") == "october" || L("text") == "oct")
  return 10;
else if (L("text") == "november" || L("text") == "nov")
  return 11;
else if (L("text") == "december" || L("text") == "dec")
  return 12;
else
  return 0;
}

##############
## MONTHTONUMSTR
## SUBJ: Convert month to number string.
## RET:	mm = month number as two digit string.
##############

monthtonumstr(L("str"))
{
if (!L("str"))
  return "00";
L("str") = str(L("str"));	# Make sure it's a string.
L("str") = strtolower(L("str"));
if (L("str") == "january" || L("str") == "jan")
  return "01";
if (L("str") == "february" || L("str") == "feb")
  return "02";
if (L("str") == "march" || L("str") == "mar")
  return "03";
if (L("str") == "april" || L("str") == "apr")
  return "04";
if (L("str") == "may")
  return "05";
if (L("str") == "june" || L("str") == "jun")
  return "06";
if (L("str") == "july" || L("str") == "jul")
  return "07";
if (L("str") == "august" || L("str") == "aug")
  return "08";
if (L("str") == "september" || L("str") == "sept" || L("str") == "sep")
  return "09";
if (L("str") == "october" || L("str") == "oct")
  return "10";
if (L("str") == "november" || L("str") == "nov")
  return "11";
if (L("str") == "december" || L("str") == "dec")
  return "12";

return "00";
}

##############
## GETRANGE
## SUBJ: Get real node for a range of rule element numbers.
## CR:	12/12/12 AM.
## RET:	[0] first node in range.
##		[1] last node in range.
##		[2] ord of first node in range.
##		[3] ord of last  node in range.
## NOTE:	More practical than getrangenodes.
## KEY:	real range, real first, real last.
## NLP++: NLP++ should provide this information.
##############

getrange(L("len"))	# Length of rule. (Or MAXIMUM LENGTH OF BATCH)
{
if (!L("len")) return 0;

if (N(1))
  {
  L("f") = eltnode(1);
  L("l") = lasteltnode(1);
  L("of") = 1;
  L("ol") = 1;
  }

if (L("len") == 1)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(2))
  {
  if (!L("f")) L("f") = eltnode(2);
  L("l") = lasteltnode(2);
  if (!L("of")) L("of") = 2;
  L("ol") = 2;
  }

if (L("len") == 2)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(3))
  {
  if (!L("f")) L("f") = eltnode(3);
  L("l") = lasteltnode(3);
  if (!L("of")) L("of") = 3;
  L("ol") = 3;
  }

if (L("len") == 3)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(4))
  {
  if (!L("f")) L("f") = eltnode(4);
  L("l") = lasteltnode(4);
  if (!L("of")) L("of") = 4;
  L("ol") = 4;
  }

if (L("len") == 4)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(5))
  {
  if (!L("f")) L("f") = eltnode(5);
  L("l") = lasteltnode(5);
  if (!L("of")) L("of") = 5;
  L("ol") = 5;
  }
if (L("len") == 5)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(6))
  {
  if (!L("f")) L("f") = eltnode(6);
  L("l") = lasteltnode(6);
  if (!L("of")) L("of") = 6;
  L("ol") = 6;
  }
if (L("len") == 6)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(7))
  {
  if (!L("f")) L("f") = eltnode(7);
  L("l") = lasteltnode(7);
  if (!L("of")) L("of") = 7;
  L("ol") = 7;
  }
if (L("len") == 7)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(8))
  {
  if (!L("f")) L("f") = eltnode(8);
  L("l") = lasteltnode(8);
  if (!L("of")) L("of") = 8;
  L("ol") = 8;
  }
if (L("len") == 8)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(9))
  {
  if (!L("f")) L("f") = eltnode(9);
  L("l") = lasteltnode(9);
  if (!L("of")) L("of") = 9;
  L("ol") = 9;
  }
if (L("len") == 9)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(10))
  {
  if (!L("f")) L("f") = eltnode(10);
  L("l") = lasteltnode(10);
  if (!L("of")) L("of") = 10;
  L("ol") = 10;
  }
if (L("len") == 10)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(11))
  {
  if (!L("f")) L("f") = eltnode(11);
  L("l") = lasteltnode(11);
  if (!L("of")) L("of") = 11;
  L("ol") = 11;
  }
if (L("len") == 11)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(12))
  {
  if (!L("f")) L("f") = eltnode(12);
  L("l") = lasteltnode(12);
  if (!L("of")) L("of") = 12;
  L("ol") = 12;
  }
if (L("len") == 12)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(13))
  {
  if (!L("f")) L("f") = eltnode(13);
  L("l") = lasteltnode(13);
  if (!L("of")) L("of") = 13;
  L("ol") = 13;
  }
if (L("len") == 13)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(14))
  {
  if (!L("f")) L("f") = eltnode(14);
  L("l") = lasteltnode(14);
  if (!L("of")) L("of") = 14;
  L("ol") = 14;
  }
if (L("len") == 14)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(15))
  {
  if (!L("f")) L("f") = eltnode(15);
  L("l") = lasteltnode(15);
  if (!L("of")) L("of") = 15;
  L("ol") = 15;
  }
if (L("len") == 15)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(16))
  {
  if (!L("f")) L("f") = eltnode(16);
  L("l") = lasteltnode(16);
  if (!L("of")) L("of") = 16;
  L("ol") = 16;
  }
if (L("len") == 16)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(17))
  {
  if (!L("f")) L("f") = eltnode(17);
  L("l") = lasteltnode(17);
  if (!L("of")) L("of") = 17;
  L("ol") = 17;
  }
if (L("len") == 17)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(18))
  {
  if (!L("f")) L("f") = eltnode(18);
  L("l") = lasteltnode(18);
  if (!L("of")) L("of") = 18;
  L("ol") = 18;
  }
if (L("len") == 18)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(19))
  {
  if (!L("f")) L("f") = eltnode(19);
  L("l") = lasteltnode(19);
  if (!L("of")) L("of") = 19;
  L("ol") = 19;
  }
if (L("len") == 19)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (N(20))
  {
  if (!L("f")) L("f") = eltnode(20);
  L("l") = lasteltnode(20);
  if (!L("of")) L("of") = 20;
  L("ol") = 20;
  }
if (L("len") == 20)
  {
  L("res")[0] = L("f");
  L("res")[1] = L("l");
  L("res")[2] = L("of");
  L("res")[3] = L("ol");
  return L("res");
  }

if (G("dev")) "error.txt" << "Rule length not handled="
	<< L("len")
	<< "\n";
return 0;
}


##############
## GETRANGENODES
## SUBJ: Get real node for a range of rule element numbers.
## RET:	[0] first node in range.
##		[1] last node in range.
##		[2] ord of first node in range.
##		[3] ord of last  node in range.
## KEY:	real range, real first, real last.
##############

getrangenodes(L("ofirst"),L("olast"))
{
if (!L("ofirst") || !L("olast"))
  return 0;
if (L("ofirst") > L("olast"))
  return 0;	# Todo: Flag error.

# Fetch the nodes.  Can assume optional ends, then look
# toward the middle for a real node!  Would simplify
# code that accounts for optionals.  Try it now....
# Account for multi-element nodes also.
L("first") = eltnode(L("ofirst"));
L("last")  = lasteltnode(L("olast"));

if (!L("first"))
  {
  L("ii") = 1 + L("ofirst");
  while (L("ii") <= L("olast"))
    {
	L("first") = eltnode(L("ii"));
	if (L("first"))
	  {
	  L("ofirst") = L("ii"); # New start ord.
	  L("ii") = L("olast") + 1; # Terminate loop.
	  }
	else
	  ++L("ii");
    }
  }
if (!L("first"))
  return 0;

if (!L("last"))
  {
  L("ii") = L("olast") - 1;
  while (L("ii") >= L("ofirst"))
    {
	L("last") = lasteltnode(L("ii"));
	if (L("last"))
	  {
	  L("olast") = L("ii"); # New end ord.
	  L("ii") = L("ofirst") - 1; # Terminate loop.
	  }
	else
	  --L("ii");
	}
  }

L("res")[0] = L("first");
L("res")[1] = L("last");
L("res")[2] = L("ofirst");
L("res")[3] = L("olast");
return L("res");	# Return array.
}

########
# FUNC:   NODETEXT
# ARGS:	  Get text of a node.
# RET:	  text or 0.
# ASS:	Using variable called "text" if node's text was
#	created explicitly.
# WARN:	GETTING LOWERCASED TEXT.
########

nodetext(L("n"))
{
#if (!L("n"))
#  return 0;
#L("text") = pnvar(L("n"),"text"); # If var present, use it.
#if (!L("text"))
#  return strtolower(pnvar(L("n"),"$text")); # Get from tokens.
#return L("text");
return nodetreetext(L("n"));	# 10/25/10 AM.
}

##############
## NODETEXT
## SUBJ: Get plain or corrected text for node.
## RET:	text for node.
## NOTE:	Text may be original, cleaned, and/or corrected.
##	Confidence may be associated with these.
##############

#nodetext(L("n"))
#{
#if (!L("n"))
#  return 0;
#L("txt") = pnvar(L("n"),"text");	# Cleaned/corrected text.
#if (L("txt"))
#  return L("txt");
#return pnvar(L("n"),"$text");	# As-is from text buffer.
#}


##############
## NODERAWTEXT
## SUBJ: Get AS-IS text for node.
## CR:   03/05/13 AM.
## RET:	 text for node.
## NOTE: Text may be original, cleaned, and/or corrected.
##	Confidence may be associated with these.
## OPT:	RETURNS AS-IS ORIGINAL TEXT SNIPPET FROM INPUT BUFFER.	# 07/20/12 AM.
##############

noderawtext(L("n"))
{
if (!L("n")) return 0;

# LIMIT SIZE OF TEXT FETCHED FROM A NODE.	# FIX.	# 08/08/12 AM.
L("max") = 255;	# *DELIVER*.				# FIX.	# 08/08/12 AM.
L("start") = pnvar(L("n"),"$ostart");				# 08/08/12 AM.
L("end") = pnvar(L("n"),"$oend");					# 08/08/12 AM.
if ((L("end") - L("start")) > L("max"))				# 08/08/12 AM.
  L("end") = L("start") + L("max");					# 08/08/12 AM.

if (L("end") < 0 || L("start") < 0)	# CHECKING	# 11/15/12 AM.
  return 0;										# 11/15/12 AM.
if (L("end") < L("start")) return 0;	# CHECKING	# 11/15/12 AM.

return inputrange(L("start"),L("end"));				# 08/08/12 AM.
}


##############
## NODETREETEXT(NEWERFORREFERENCE)
##############

nodetreetextNEWERFORREFERENCE(L("n"))
{
if (!L("n")) return 0;

# Some nodes get a text built for them.				# 02/27/13 AM.
if (L("tt") = pnvar(L("n"),"text")) return L("tt");	# 02/27/13 AM.

# LIMIT SIZE OF TEXT FETCHED FROM A NODE.	# FIX.	# 08/08/12 AM.
L("max") = 255;	# *DELIVER*.				# FIX.	# 08/08/12 AM.
L("start") = pnvar(L("n"),"$ostart");				# 08/08/12 AM.
L("end") = pnvar(L("n"),"$oend");					# 08/08/12 AM.
if ((L("end") - L("start")) > L("max"))				# 08/08/12 AM.
  L("end") = L("start") + L("max");					# 08/08/12 AM.

if (L("end") < 0 || L("start") < 0)	# CHECKING	# 11/15/12 AM.
  return 0;										# 11/15/12 AM.
if (L("end") < L("start")) return 0;	# CHECKING	# 11/15/12 AM.

return inputrange(L("start"),L("end"));				# 08/08/12 AM.
}

##############
## NODETREETEXT
## SUBJ: Get plain, corrected, or modified text for node.
## RET:	text for node.
## NOTE:	Text may be original, cleaned, and/or corrected.
##	Confidence may be associated with these.
##############

nodetreetext(L("n"))
{
if (!L("n"))
  return 0;
L("txt") = pnvar(L("n"),"text");	# Cleaned/corrected text.

if (L("txt"))
  return L("txt");

#return pnvar(L("n"),"$treetext");	# As-is from parse tree.
return prosify(L("n"),"text");	# 09/07/08 AM.
}


##############
## NODESTREETEXT
## SUBJ: Get plain or corrected text for a range of nodes.
## RET:	text for nodes.
## NOTE:	Text may be original, cleaned, and/or corrected.
##	"NOSP" - if two nodes are not separated by whitespace, should
##		set to 1.  Else zero.
##	"text" - If this is present on a node, then it is used without
##		traversing inside the node.
##############

nodestreetext(
	L("s"),	# Start of range.
	L("e")	# End of range
	)
{
if (!L("s"))
  return 0;
if (L("e"))
  L("z") = pnnext(L("e"));
L("n") = L("s");
L("str") = 0;
G("LEN") = 0;	# TRACK AND LIMIT COLLECTED LENGTH TO G("MAX").
while (L("n") && L("n") != L("z"))
  {
  L("str") = prosifyrec(
	L("n"),		# Root node of subtree.
	"text",		# Name of user-supplied text field.
	L("str"),	# The glommed string so far.
	1			# Flag if root or not.
	);

  if (G("LEN") >= G("MAX")) {G("LEN") = 0; return L("str"); }	# TRACK AND LIMIT.
  L("n") = pnnext(L("n"));
  }
return L("str");
}

# The old nodestreetext.
#if (!L("s"))
#  return 0;
#
#if (L("e"))
#  L("e") = pnnext(L("e"));
#
#while (L("s") && L("s") != L("e"))
#  {
#  L("txt") = L("txt") + nodetreetext(L("s"));
#  L("s") = pnnext(L("s"));
#  }
#return L("txt");

##############
## PHRASETREETEXT
## SUBJ: Get plain or corrected text for node's top level phrase.
## RET:	text for node.
## NOTE:	Follow given "root" node down till a "text"
##	variable is seen or until it branches out.  Then
##	traverse at that branched level.
##############

phrasetreetext(L("root"))
{
return prosify(L("root"),"text");

#if (!L("root"))
#  return 0;
#
#L("n") = L("root");
#L("done") = 0;
#while (L("n") && !L("done"))
#  {
#  L("txt") = pnvar(L("n"),"text");	# Cleaned/corrected text.
#  if (L("txt"))
#    return L("txt");
#  if (pnnext(L("n")))
#    L("done") = 1;
#  else
#    L("n") = pndown(L("n"));	# Go down a level.
#  }
#
#if (!L("n"))
#  return nodetreetext(L("root"));
#  
#return nodestreetext(pndown(L("n")),0);
}

##############
## STRSTARTSWITH
## SUBJ: See if string starts with given substr.
## RET:	1 if so, else 0.
## NOTE:	NLP++ should have this, analogous to strendswith.
##############

strstartswith(L("str"),L("substr"))
{
if (!L("str") || !L("substr"))
  return 0;
L("len") = strlength(L("substr"));
if (strlength(L("str")) < L("len"))
  return 0;
if (strpiece(L("str"),0,L("len")-1) == L("substr"))
  return 1;
return 0;
}

##############
## STRDETAG
## SUBJ: Get rid of HTML tags from a string.
## RET:	str = trimmed string.
## NOTE:	Assuming no lone < and > signs.
##############

strdetag(L("str"))
{
if (!L("str"))
  return 0;

# Build a new string.
L("new") = 0;

# Traverse string one char at a time. OPT=inefficient in
# NLP++ currently.
L("len") = strlength(L("str"));
L("ii") = 0;	# Current position in string.
L("ch") = strpiece(L("str"),0,0);	# Lookahead char.
L("outside") = 1;	# If outside of a tag.
while (L("ch"))
  {
  if (L("ch") == ">")
    L("outside") = 1;
  else if (L("ch") == "<")
    L("outside") = 0;
 else if (!L("outside"))	# Inside a tag.
   ;	# Ignore chars inside tag.
 else # Outside a tag.
    L("new") = L("new") + L("ch");

  ++L("ii");	# Next char position.
  if (L("ii") >= L("len"))
    return L("new");
  L("ch") = strpiece(L("str"),L("ii"),L("ii"));
  }
return L("new");
}

##############
## PNPARENT
## SUBJ: Fetch parse tree node's parent.
##############

pnparent(L("n"))
{
if (!L("n"))
  return 0;

# Get first node in list.
while (L("x") = pnprev(L("n")))
  {
  L("n") = L("x");
  }
return pnup(L("n"));
}

########
# FUNC: NUMBER
# SUBJ:	Check singular/plural/any for noun.
# ARGS: Noun node.
# RET:	"singular", "plural", "any", or 0.
# ASS:	Should return any for mass nouns, things like sheep...
# TODO:	Irregular plurals.  radii, cherubim, etc.
########

number(L("n"))
{
if (!L("n"))
  {
  return 0;
  }
if (pnvar(L("n"),"-s"))
  return "plural";
L("num") = pnvar(L("n"),"number");
if (L("num"))
  return L("num");

L("ntext") = nodetext(L("n"));
if (!L("ntext"))
  {
  return 0;
  }
L("stem") = pnvar(L("n"),"stem");
if (!L("stem"))
  L("stem") = nvstem(L("ntext"));
#"stem.txt" << "stem,text=" << L("stem") << "," << L("ntext") <<"\n";
if (strendswith(L("ntext"),"s")
 && L("stem") != L("ntext") )
  return "plural";
return "singular";
}

########
# FUNC:	SINGULAR
# SUBJ:	True if noun can be singular.
# ARGS: Noun node.
# RET:	1 or 0.
# ASS:	Should return true for mass nouns, things like sheep...
# TODO:	Irregular plurals.  radii, cherubim, etc.
########

singular(L("n"))
{
if (!L("n"))
  return 0;
if (pnvar(L("n"),"-s"))
  return 0;
L("pl") = pnvar(L("n"),"number");
if (L("pl") == "singular")
  return 1;
else if (L("pl") == "plural")
  return 0;
if (pnvar(L("n"),"number") == "singular")
  return 1;

L("ntext") = nodetext(L("n"));
if (!L("ntext"))
  return 0;
L("stem") = pnvar(L("n"),"stem");
if (!L("stem"))
  L("stem") = nvstem(L("ntext"));
if (strendswith(L("ntext"),"s")
 && L("stem") != L("ntext") )
  return 0;
return 1;
}


########
# FUNC:	PLURAL
# SUBJ:	True if noun can be plural.
# ARGS: Noun node.
# RET:	1 or 0.
# ASS:	Should return true for mass nouns, things like sheep...
# TODO:	Irregular plurals.  radii, cherubim, etc.
########

plural(L("n"))
{
if (!L("n"))
  return 0;
if (pnvar(L("n"),"-s"))
  return 1;
if (pnvar(L("n"),"number") == "plural")
  return 1;

L("ntext") = nodetext(L("n"));
if (!L("ntext"))
  return 0;
L("stem") = pnvar(L("n"),"stem");
if (!L("stem"))
  L("stem") = nvstem(L("ntext"));
if (strendswith(L("ntext"),"s")
 && L("stem") != L("ntext") )
  return 1;
return 0;
}

########
# FUNC:	NUMBERV
# SUBJ:	See if verb needs singular/plural noun.
########
numberv(L("n"))
{
if (!L("n"))
  return 0;

if (pnname(L("n")) == "_vg")
	{
	L("d") = down(L("n"));
	if (pnname(L("d")) == "_modal")
	  return "any";
	L("t") = nodetext(L("d"));
	if (pnname(L("d")) == "_have")
		{
		if (L("t") == "have")
			return "plural";
		else if (L("t") == "has")
			return "singular";
		else
			return "any";
 		}
	if (pnname(L("d")) == "_be")
		{
		if (L("t") == "am")
			return "singular";
		if (L("t") == "are")
			return "plural";
		if (L("t") == "is")
			return "singular";
		if (L("t") == "was")
			return "singular";
		if (L("t") == "were")
			return "plural";
		}
	if (pnname(L("d")) == "_being")
		return "any";

	L("n") = pnvar(L("n"),"verb node");
	if (!L("n"))
	  return 0;
	}

if (vconjq(L("n"),"-s"))
	return "singular";
if (vconjq(L("n"),"inf"))
	return "plural";

		# Assume 3rd person noun previous.
L("t") = nodetext(L("n"));
"numv.txt" << L("t") << "\n";
		if (L("t") == "am")
			return "singular";
		if (L("t") == "are")
			return "plural";
		if (L("t") == "is")
			return "singular";
		if (L("t") == "was")
			return "singular";
		if (L("t") == "were")
			return "plural";

		if (L("t") == "have")
			return "plural";
		else if (L("t") == "has")
			return "singular";
		else
			return "any";

return "any";
}

########
# FUNC:	NUMBERSAGREE
# SUBJ:	True if range of nodes agree in numbering.
# RET:	Agreed on number or 0 if fail.
# NOTE: Changing this to be for a noun phrase.  "Is this NP complete" (sic)
#	If no singular indicators, then end of noun phrase must be plural.
########

numbersagree(L("start"),L("end"))
{
if (!L("start") || !L("end"))
  {
  "err.txt" << "numbersagree: " << phrasetext() << "\n";
  "err.txt" << "   " << G("$passnum") << "," << G("$rulenum") << "\n";
  return 0;
  }
if (L("start") == L("end"))
  {
  L("need") = number(L("start"));
  if (L("need"))
    return L("need");
  return "any";	# Node agrees with itself.
  }
L("last") = L("end");
L("end") = pnnext(L("end"));
L("n") = L("start");
L("agree") = 1; # Agreement so far.
L("need") = "any"; # Constraint to be satisfied.
while (L("n") != L("end"))
  {
  L("nm") = pnname(L("n"));
  L("number") = 0; # Reset.
  if (L("nm") == "_noun" && L("n") != L("last"))
    ; # IGNORE nonhead nouns.
  else if (pnvar(L("n"),"number"))
    {
    L("number") = pnvar(L("n"),"number");
    if (pnvar(L("n"),"mass-ok"))
      L("mass-ok") = 1;
	}
  else if (pnvar(L("n"),"num"))
    {
	L("num") = pnvar(L("n"),"num");
	if (L("num") == 1)
	  L("number") = "singular";
	else
	  L("number") = "plural";
	L("mass-ok") = 0;
	}
#  else if (pnvar(L("n"),"noun"))
#    L("number") = number(L("n"));
  else if (strisdigit(pnvar(L("n"),"$text"))) # 10/19/04 AM.
    {
	L("nm") = num(pnvar(L("n"),"$text"));
	if (L("nm") == 1)
	  L("number") = "singular";
	else
	  L("number") = "plural";
	L("mass-ok") = 0;
	}
  # Should also check final alpha (ie as noun...) # 10/19/04 AM.
  else if (L("n") == L("last"))
    {
	L("number") = number(L("n"));
	}

  if (L("number"))
    {
	if (L("need") == "any")
	  L("need") = L("number");
	else if (L("need") != L("number"))
	  {
	  if (!L("mass-ok") || !massnoun(L("n")))
	    return 0;	# Disagreement.
	  }
	}
  L("n") = pnnext(L("n"));
  }
if (L("need"))
  return L("need");
return "any";	# Agreement.
}

########
# FUNC:	MASSNOUN
# SUBJ:	True if node can be a mass noun.
# RET:########

massnoun(L("n"))
{
if (!L("n"))
  return 0;
if (pnvar(L("n"),"mass"))
  return 1;
L("t") = nodetext(L("n"));
if (!L("t"))
  return 0;
if (pnvar(L("n"),"noun") || pnvar(L("n"),"unknown"))
  {
  if (strendswith(L("t"),"ing"))
    return 1;
  }
return 0;
}

########
# FUNC:	NONLITERAL
# SUBJ:	Check if node is nonliteral (should be NLP++ fn...).
########

nonliteral(L("n"))
{
if (!L("n"))
  return 0;
L("nm") = pnname(L("n"));
if (strpiece(L("nm"),0,0) == "_")
  return 1;
return 0;
}

########
# FUNC:	LITERAL
# SUBJ:	See if node is literal.
# NOTE:	Check if node is literal (should be NLP++ fn...).
########

literal(L("n"))
{
if (!L("n"))
  return 0;
L("name") = pnname(L("n"));
if (strpiece(L("name"),0,0) != "_")
  return 1;
if (strlength(L("name")) == 1) # Name is the underscore char.
  return 1;
return 0;
}

######
# FN:  PROSIFYSIMPLE
# SUBJ: Convert subtree to a prose-like string.
# CR:  03/26/03 AM.
# NOTE: Assuming all blanks are gone.
#	Simple one-level traverse of children.
#####

prosifysimple(L("root"))
{
if (!L("root"))
  return 0;
L("node") = pndown(L("root"));
if (!L("node"))
  return pnvar(L("root"),"$text");

# Traverse nodes, sticking in spaces.
L("noafter") = 0;
L("str") = pnvar(L("node"),"$text");
while (L("node") = pnnext(L("node")) )
  {
  # Need ispunct.
  L("txt") = pnvar(L("node"),"$text");
  if (L("txt") != "."
   && L("txt") != ","
   && L("txt") != "-"
   && L("txt") != "'"
   && !L("noafter")
   )
    L("str") = L("str") + " ";  # Add space BEFORE current word.
  if (L("txt") == "-"
   || L("txt") == "'")
    L("noafter") = 1;	# No space after, also.
  else
    L("noafter") = 0;
  L("str") = L("str") + pnvar(L("node"),"$text");
  }
return L("str");
}

######
# FN:	PROSIFY
# SUBJ: Convert subtree to a prose-like string.
# NOTE: User-supplied text field for nodes with a rebuilt
#	text.  Assume space after node unless next is sentence
#	punctuation.  If space in tree, use that.
# TODO:	What to do with existing whitespace.
#	Options to generate newlines.
#	NLP++ function like PNPROSE to hard-wire this.
# RET:	catenated string.
#		RECURSIVE.
#####

prosify(
	L("root"),	# Node whose text we're fetching.
	L("field")	# Name of user-supplied text field on nodes.
	)
{
if (!L("root"))
  return 0;

G("LEN") = 0;	# TRACK AND LIMIT COLLECTED LENGTH TO G("MAX").
return prosifyrec(L("root"),L("field"),0,1);
}

######
# FN:  PROSIFYREC
# SUBJ: Convert subtree to a prose-like string.
# NOTE: Recursive part of prosify.
# RET:  catenated string.
#####

#prosifyrec(
#	L("root"),
#	L("field"),	# Name of user-supplied text field.
#	L("str"),	# The glommed string so far.
#	L("flag")	# Flag if root or not.
#	)
#{
#if (!L("root"))
#  return L("str");
#
#if (L("field"))
#  {
#  L("txt") = pnvar(L("root"),L("field"));
#  
#  if (L("str") && L("txt"))
#    {
#	if (pnvar(L("root"),"NOSP"))
#      L("str") = L("str") + L("txt");
#	else
#      L("str") = L("str") + " " + L("txt");
#	}
#  else if (L("txt"))
#    L("str") = L("txt");
#
#  if (L("txt") && L("flag"))
#    return L("str");	# Done!
#  }
#
#L("nm") = pnname(L("root"));
# NLP++: Need strispunct.
# If literal vs nonliteral.
#L("ch") = strpiece(L("nm"),0,0);
#if (L("txt"))	# Done with current node.
#  ;
#else if (L("ch") != "_" || L("nm") == "_")  # Literal. Alpha, num, punct, etc.
#  {
#  # Above, lone underscore is a punctuation, not a nonliteral.
#  if (!L("str"))
#    L("str") = L("nm");
#  else if (pnvar(L("root"),"NOSP"))
#    L("str") = L("str") + L("nm");
#  else if (L("ch") == " " || L("ch") == "\t" || L("ch") == "\n")
#    # If text is whitespace. # 10/08/09 AM.
#	;	# IGNORE WHITESPACE # 10/09/09 AM.
#  else
#    L("str") = L("str") + " " + L("nm");
#  }
#else	# Nonliteral.
#  # Handle my subtree.
#  L("str") = prosifyrec(pndown(L("root")),L("field"),L("str"),0);
#
#if (pnprev(L("root")))
#  return L("str");
#
# First in a list, handle the list.
#if (L("flag"))
#  return L("str");
#while (L("root") = pnnext(L("root")))
#  L("str") = prosifyrec(L("root"),L("field"),L("str"),1);
#return L("str");
#}

prosifyrec(
	L("root"),
	L("field"),	# Name of user-supplied text field.
	L("str"),	# The glommed string so far.
	L("flag")	# Flag if root or not.
	)
{
if (!L("root"))
  return L("str");

if (L("field"))
  {
  L("txt") = pnvar(L("root"),L("field"));
  
  if (L("str") && L("txt"))
    {
	if (!pnvar(L("root"),"NOSP"))
	  {
	  ++G("LEN");
	  L("str") = L("str") + " ";
	  if (G("LEN") >= G("MAX")) return L("str");	# TRACK AND LIMIT.
	  }
	# NOSP is true or we've already added its space char.

	L("len") = strlength(L("txt"));	# TRACK AND LIMIT.
	L("tot") = G("LEN") + L("len");	# TRACK AND LIMIT.

#	if (pnvar(L("root"),"NOSP"))
#	  {
#      L("str") = L("str") + L("txt");	# When life was a little simpler.
	  if (L("tot") < G("MAX"))	# TRACK AND LIMIT.
	    {
        L("str") = L("str") + L("txt");
		G("LEN") = L("tot");	# TRACK AND LIMIT.
		}
	  else if (L("tot") > G("MAX"))	# TRACK AND LIMIT.
	    {
		L("del") = G("MAX") - G("LEN");
		L("xx") = strpiece(L("txt"),0,L("del")-1);
		L("str") = L("str") + L("xx");
		G("LEN") = G("MAX");	# TRACK AND LIMIT.
		return L("str");
		}
	  else	# Exactly equal max length.
	    {
        L("str") = L("str") + L("txt");
		G("LEN") = G("MAX");	# TRACK AND LIMIT.
		return L("str");
		}
#	  }

	} # END   if (L("str") && L("txt"))
  else if (L("txt"))
    L("str") = L("txt");

  if (L("txt") && L("flag"))
    return L("str");	# Done!
  } # END if L("field")

# TRACK AND LIMIT. Presumably there are limits on node name length & token length.
L("nm") = pnname(L("root"));
# NLP++: Need strispunct.
# If literal vs nonliteral.
L("ch") = strpiece(L("nm"),0,0);
if (L("txt"))	# Done with current node.
  ;
else if (L("ch") != "_" || L("nm") == "_")  # Literal. Alpha, num, punct, etc.
  {
  # Above, lone underscore is a punctuation, not a nonliteral.

  if (L("str") && !pnvar(L("root"),"NOSP"))
	  {
	  ++G("LEN");
	  L("str") = L("str") + " ";
	  if (G("LEN") >= G("MAX")) return L("str");	# TRACK AND LIMIT.
	  }
  # NOSP is true or we've already added its space char. Or we had no str.

  L("len") = strlength(L("nm"));	# TRACK AND LIMIT.
  L("tot") = G("LEN") + L("len");	# TRACK AND LIMIT.

  # Flag if whitespace literal.
  if (L("ch") == " " || L("ch") == "\t" || L("ch") == "\n") ++L("WHITE");

  if (!L("str"))
    {
	if (L("tot") < G("MAX"))
	  {
      L("str") = L("nm");
	  G("LEN") = L("tot");
	  }
	else if (L("tot") > G("MAX"))	# HUGE TOKEN!
	  {
		L("del") = G("MAX") - G("LEN");
		L("xx") = strpiece(L("nm"),0,L("del")-1);
		L("str") = L("xx");
		G("LEN") = G("MAX");	# TRACK AND LIMIT.
		return L("str");
	  }
	else # Exactly equal G("MAX").
	  {
        L("str") = L("nm");
		G("LEN") = G("MAX");	# TRACK AND LIMIT.
		return L("str");
	  }
	}
  else if (pnvar(L("root"),"NOSP") || !L("WHITE"))
    {
#    L("str") = L("str") + L("nm");
	  if (L("tot") < G("MAX"))	# TRACK AND LIMIT.
	    {
        L("str") = L("str") + L("nm");
		G("LEN") = L("tot");	# TRACK AND LIMIT.
		}
	  else if (L("tot") > G("MAX"))	# TRACK AND LIMIT.
	    {
		L("del") = G("MAX") - G("LEN");
		if (L("del") > 0)	# FIX.	# 10/12/11 AM.
		  {
		  L("xx") = strpiece(L("nm"),0,L("del")-1);
		  L("str") = L("str") + L("xx");
		  }
		G("LEN") = G("MAX");	# TRACK AND LIMIT.
		return L("str");
		}
	  else	# Exactly equal max length.
	    {
        L("str") = L("str") + L("nm");
		G("LEN") = G("MAX");	# TRACK AND LIMIT.
		return L("str");
		}
	} # END of NOSP or !WHITE

#  else if (L("ch") == " " || L("ch") == "\t" || L("ch") == "\n")
    # If text is whitespace. # 10/08/09 AM.
#	;	# IGNORE WHITESPACE # 10/09/09 AM.
#  else	
#  	{
#    L("str") = L("str") + " " + L("nm");
#	}

  } # END if literal

else	# Nonliteral.
  # Handle my subtree.
  L("str") = prosifyrec(pndown(L("root")),L("field"),L("str"),0);

if (pnprev(L("root")))
  return L("str");

# First in a list, handle the list.
if (L("flag"))
  return L("str");
while (L("root") = pnnext(L("root")))
  L("str") = prosifyrec(L("root"),L("field"),L("str"),1);
return L("str");
}

######
# FN:  SAMEVCONJ
# SUBJ: See if compatible verb conjugations.
# CR:	10/17/04 AM.
# RET:	Most constrained fit.
# TODO: Handle ambiguous verb conjugations.
#####

samevconj(L("v1"),L("v2"))
{
if (!L("v1") || !L("v2"))
  return 0;
#"samevc.txt" << pnvar(L("v1"),"$text")
#	<< "," << pnvar(L("v2"),"$text") << "\n";
L("vc1") = vconj(L("v1"));
L("vc2") = vconj(L("v2"));
#"samevc.txt" << L("vc1") << L("vc2") << "\n";
if (L("vc1") == L("vc2"))
  return L("vc1");

# For ambiguous cases...
# Todo: Doesn't necessarily work if BOTH are ambig.
if (vconjq(L("v1"),L("vc2")))
  return L("vc2");
if (vconjq(L("v2"),L("vc1")))
  return L("vc1");

# Now check out -edn -ed -en.
if (L("vc1") != "-edn" && L("vc2") != "-edn")
  return 0;
if (L("vc1") == "-en" || L("vc2") == "-en")
  return "-en";
if (L("vc1") == "-ed" || L("vc2") == "-ed")
  return "-ed";
return 0;	# Error.
}

######
# FN:  ISNEWSENTENCE
# SUBJ: See if node starts a new sentence.
# CR:	01/15/05 AM.
# RET:	1 if true, else 0.
#####

isnewsentence(L("node"))
{
if (!L("node"))
  return 0;
L("prev") = pnprev(L("node"));
if (!L("prev"))
  return 1;
L("name") = pnname(L("prev"));
if (L("name") == "_qEOS"
 || L("name") == "_dbldash"
 || L("name") == "\"")
  return 1;  # Tentatively...
return 0;
}

######
# FN:  ELLIPTEDPASSIVE
# SUBJ: See if node is passive subclause.
# CR:	01/25/05 AM.
# RET:	1 if true, else 0.
# EG:	John, bitten by lice, is mad...
######

elliptedpassive(L("clause"))
{
if (!L("clause"))
  return 0;
L("vg") = pnvar(L("clause"),"vg node");
if (!L("vg"))
  return 0;
if (pnvar(L("clause"),"voice") != "passive")
  return 0;
L("v") = pnvar(L("vg"),"first verb");
if (!L("v"))
  return 0;
if (pnvar(L("v"),"mypos") != "VBN")
  return 0;
return 1;
}

######
# FN:  ELLIPTEDACTIVE
# SUBJ: See if node is ving.
# CR:	03/02/05 AM.
# RET:	1 if true, else 0.
# EG:	John, biting nails, is mad...
######
elliptedactive(L("clause"))
{
if (!L("clause"))
  return 0;
L("vg") = pnvar(L("clause"),"vg node");
if (!L("vg"))
  return 0;
if (pnvar(L("clause"),"voice") != "active")
  return 0;
L("v") = pnvar(L("vg"),"first verb");
if (!L("v"))
  return 0;
if (pnvar(L("v"),"mypos") == "VBG")
  return 1;
if (vconjq(L("v"),"-ing"))
  return 1;
return 0;
}

######
# FN:  PNNAMEINRANGE
# SUBJ: See if list of nodes has name.
# CR:	02/12/05 AM.
# RET:	first node found.
######

pnnameinrange(L("name"),L("start"),L("end"))
{
if (!L("name") || !L("start"))
  return 0;
if (L("end"))
  L("end") = pnnext(L("end"));
L("node") = L("start");
while (L("node"))
  {
  if (pnname(L("node")) == "_advl")
    return L("node");
  if (L("node") == L("end"))
    return 0;
  L("node") = pnnext(L("node"));
  }
}

######
# FN:  ATTRINRANGE
# SUBJ: See if list of nodes has attr.
# RET:	First value found.
######

attrinrange(L("name"),L("start"),L("end"))
{
if (!L("name") || !L("start"))
  return 0;
if (L("end"))
  L("end") = pnnext(L("end"));
L("node") = L("start");
while (L("node"))
  {
  L("val") = pnvar(L("node"),L("name"));
  if (L("val"))
    return L("val");
  if (L("node") == L("end"))
    return 0;
  L("node") = pnnext(L("node"));
  }
}

######
# FN:  PNREPLACEVALRANGE
# SUBJ: Replace value in range of nodes.
# CR:	02/18/05 AM.
######
pnreplacevalrange(L("var"),L("val"),L("start"),L("end"))
{
if (!L("var") || !L("start"))
  return;
if (L("end"))
  L("end") = pnnext(L("end"));
L("node") = L("start");
while (L("node"))
  {
  if (L("node") == L("end"))
    return;
  pnreplaceval(L("node"),L("var"),L("val"));
  L("node") = pnnext(L("node"));
  }
}

######
# FN:  VVAGREE
# SUBJ: See if tenses of 2 verbs agree.
# NOTE:
######
vvagree(L("n1"),L("n2"))
{
if (!L("n1") || !L("n2"))
  fail();

L("nm1") = pnname(L("n1"));
L("nm2") = pnname(L("n2"));
if (L("nm1") == "_vg" && L("nm2") == "_vg")
  return vgvgagree(L("vg1"),L("vg2"));

if (L("nm1") == "_vg")
  L("v1") = pnvar(L("n1"),"first verb");
else
  L("v1") = L("n1");

if (L("nm2") == "_vg")
  L("v2") = pnvar(L("n2"),"first verb");
else
  L("v2") = L("n2");

return verbverbagree(L("v1"),L("v2"));
}


######
# FN:  VGVGAGREE
# SUBJ: See if tenses of 2 vgs agree.
# CR:	04/15/05 AM.
######
vgvgagree(L("vg1"),L("vg2"))
{
if (!L("vg1") || !L("vg2"))
  return 0;
L("first1") = pnvar(L("vg1"),"first verb");
L("first2") = pnvar(L("vg2"),"first verb");

return verbverbagree(L("first1"),L("first2"));
}

######
# FN:  VERBVERBAGREE
# SUBJ: See if tenses of 2 verbs agree.
######
verbverbagree(L("first1"),L("first2"))
{
if (!L("first1") || !L("first2"))
  return 0;
L("vc1") = vconj(L("first1"));
L("vc2") = vconj(L("first2"));
#"vgvg.txt" << pnvar(L("first1"),"$text") << "," << pnvar(L("first2"),"$text") << "\n";
#"vgvg.txt" << L("vc1") << "," << L("vc2") << "\n";
if (L("vc1") == L("vc2"))
  return 1;
if (pnvar(L("first1"),"inf")
 && pnvar(L("first2"),"inf"))
  return 1;
if (pnvar(L("first1"),"-s")
 && pnvar(L("first2"),"-s"))
  return 1;
if (pnvar(L("first1"),"-ing")
 && pnvar(L("first2"),"-ing"))
  return 1;
if (pnvar(L("first1"),"-ed")
 && pnvar(L("first2"),"-ed"))
  return 1;
if (pnvar(L("first1"),"-en")
 && pnvar(L("first2"),"-en"))
  return 1;
# Check compatibles.
# Check ambiguous.
if (pnvar(L("first1"),"-edn"))
  {
  if (pnvar(L("first2"),"-edn")
   || pnvar(L("first2"),"-en")
   || pnvar(L("first2"),"-ed") )
   return 1;
  }
if (pnvar(L("first2"),"-edn"))
  {
  if (pnvar(L("first1"),"-en")
   || pnvar(L("first1"),"-ed") )
   return 1;
  }

return 0;
}

########
# FUNC:	PNADDSTR
# SUBJ:	Add string to a node's variable.
# EX:	pnaddstr(N(2),"hello","newstr");
# NOTE:	For adding multiple values to a variable.
########
pnaddstr(
	L("node"),	# Node we are adding info to.
	L("field"),
	L("str")
	)
{
if (!L("node") || !L("field") || !L("str"))
  return;
L("vals") = pnvar(L("node"),L("field"));
if (!L("vals"))
  L("len") = 0;
else
  L("len") = arraylength(L("vals"));

# Can't directly append a new value onto node.
# Need something like pnaddval(L("node"),L("field"),L("str")).
L("vals")[L("len")] = L("str");
pnreplaceval(L("node"),L("field"),L("vals"));
}


########
# FUNC:   GETDATE
# SUBJ:   Compute a date string.
########

getdate(L("n"))
{
if (!L("n"))
  return 0;
L("yr") = pnvar(L("n"),"yr");
L("dy") = pnvar(L("n"),"dy");
L("mo") = pnvar(L("n"),"mo");
if (!L("yr") && !L("mo"))
  return 0;

if (!L("yr"))
  {
  if (L("mo") == 11 || L("mo") == 12)
    L("yr") = 2004;
  else
    L("yr") = 2005;
  }

if (!L("mo"))
  return str(L("yr")) + "-00-00";

if (L("mo") < 10)
  L("mo") = "0" + str(L("mo"));
if (L("dy") < 10)
  L("dy") = "0" + str(L("dy"));

return str(L("yr")) + "-"
  	+ str(L("mo")) + "-"
	+ str(L("dy"));
}

########
# FUNC:   NVSTEM
# SUBJ:   Compute stem for word.
# NOTE:	  NLP++ stem() sucks, should do more of the below.
########

nvstem(L("txt"))
{
if (!L("txt"))
  return 0;
L("lc") = strtolower(L("txt"));
# Can do more accurate if it's a known word.
if (spellword(L("lc")))
  return nvstemknown(L("lc"));
else
  return nvstemunk(L("lc"));
}

########
# FUNC:   NVSUFF
# SUBJ:   Compute suffix for noun or verb.
# NOTE:	  NLP++ stem() sucks, should do more of the below.
########

nvsuff(L("txt"))
{
if (!L("txt"))
  return L("txt");
L("lc") = strtolower(L("txt"));
L("stem") = nvstem(L("txt"));
if (L("stem") == L("lc"))
  return "inf";
# Got some kind of stemming.
if (strendswith(L("lc"),"s"))
  return "-s";
if (strendswith(L("lc"),"d"))
  return "-edn";
if (strendswith(L("lc"),"g"))
  return "-ing";
if (strendswith(L("lc"),"n"))
  return "-en";
}

########
# FUNC:   NVSTEMKNOWN
# SUBJ:   Compute stem for known word.
# NOTE:	NOT HANDLING IRREGULAR VERBS.
########

nvstemknown(L("lc"))
{
if (!L("lc"))
  return 0;

# EXCEPTIONS HERE.
# (They should be in the kb, etc.)
if (L("lc") == "ironed"
 || L("lc") == "ironing")
  return "iron";

# Look for EXTENSIONS in dictionary.
# Try adding an "-ing".
#L("x") = L("lc") + "ing";
#if (spellword(L("x")))
#  return L("lc");
#
# Try adding an "-s".
#L("x") = L("lc") + "s";
#if (spellword(L("x")))
#  return L("lc");

# Look for suffixes.
# Check doubled letters...

# -ss
if (strendswith(L("lc"),"ss"))
  return L("lc");


L("len") = strlength(L("lc"));
if (L("len") <= 3)
  return L("lc");	# As is.

if (L("len") > 4)
  {
  # -ies => -y
  # -ied => -y
  if (strendswith(L("lc"),"ies")
   || strendswith(L("lc"),"ied"))
    {
	# Try lopping off the s.
	L("x") = strpiece(L("lc"),0,L("len")-2);
	if (spellword(L("x")))
	  return L("x");

	# Lop off ies, add y.
	L("x") = strpiece(L("lc"),0,L("len")-4) + "y";
	if (spellword(L("x")))
	  return L("x");

	# Lop off es. (-ies => -i)
	L("x") = strpiece(L("lc"),0,L("len")-3);
	if (spellword(L("x")))
	  return L("x");

	# Nothing worked. Return as is.
	return L("lc");
	}

  # -ing =>
  # -ing => -e
  # doubled
  if (strendswith(L("lc"),"ing"))
    {
	L("x") = strpiece(L("lc"),0,L("len")-4);

	# Check doubling.
	if (strpiece(L("lc"),L("len")-4,L("len")-4)  ==
	    strpiece(L("lc"),L("len")-5,L("len")-5) )
	  {
	  # Check as is.
	  if (spellword(L("x")))
	    return L("x");

	  # Remove doubling.
	  L("y") = strpiece(L("x"),0,L("len")-5);
	  if (spellword(L("y")))
	    return L("y");

	  return L("lc");
	  }

	# Check -ing => -e
	L("y") = L("x") + "e";
	if (spellword(L("y")))
	  return L("y");

	# -ing => 0
	if (spellword(L("x")))
	  return L("x");

	# Nothing worked, return as is.
	return L("lc");
	}

  # -es  => -e
  # -es  => 0
  if (strendswith(L("lc"),"es"))
    {
	L("x") = strpiece(L("lc"),0,L("len")-3);
	
	L("y") = L("x") + "e";
	if (spellword(L("y")))
	  return L("y");

	if (spellword(L("x")))
	  return L("x");

	return L("lc");
	}

  # -ed => -e
  # doubled
  # -ed =>
  if (strendswith(L("lc"),"ed"))
    {
	L("x") = strpiece(L("lc"),0,L("len")-3);

	# Check doubling.
	if (strpiece(L("x"),L("len")-3,L("len")-3) ==
	    strpiece(L("x"),L("len")-4,L("len")-4))
	  {
	  L("y") = strpiece(L("x"),0,L("len")-4);
	  if (spellword(L("y")))
	    return L("y");
	  }

	# Add an e.
	L("y") = L("x") + "e";
	if (spellword(L("y")))
	  return L("y");

	if (spellword(L("x")))
	  return L("x");

	return L("lc");
	}

  }

# -s   =>
if (strendswith(L("lc"),"s"))
  {
  L("x") = strpiece(L("lc"),0,L("len")-2);
  if (spellword(L("x")))
    return L("x");
  }

return L("lc");
}

########
# FUNC:   NVSTEMUNK
# SUBJ:   Compute possible stem for unknown word.
########

nvstemunk(L("lc"))
{
if (!L("lc"))
  return 0;

# Look for suffixes.
# -ss
# -ies => -y
# -es  => -e
# -s   =>

# -ing =>
# -ing => -e

# -ied => -y
# -ed => -e
# -ed =>


}

########
# FUNC:   NODEFEAT
# SUBJ:   If node's stem has feature.
########

nodefeat(L("n"),L("feat"))
{
if (!L("n") || !L("feat"))
  return 0;

L("lctxt") = nodestem(L("n"));
if (!L("lctxt"))
  {
  "blupp.txt" << pnvar(L("n"),"$text") << "\n";
  return 0;
  }
L("lctxt") = strtolower(L("lctxt"));
return finddictattr(L("lctxt"),L("feat"));
}

########
# FUNC:   VERBFEAT
# SUBJ:   If verb's stem has feature.
########

verbfeat(L("n"),L("feat"))
{
if (!L("n") || !L("feat"))
  return 0;

if (pnvar(L("n"),"compound-vg"))
  L("n") = pnvar(L("n"),"last vg");

if (!L("n"))
  {
  "err.txt" << "verbfeat: " << phrasetext() << "\n";
  "err.txt" << "  " << G("$passnum") << "," << G("$rulenum") << "\n";
  }
L("nm") = pnname(L("n"));
if (L("nm") == "_vg")
  L("v") = pnvar(L("n"),"verb node");
else
  L("v") = L("n");

if (!L("v"))
  return 0;

L("lctxt") = nodestem(L("v"));
if (!L("lctxt"))
  {
  "blup.txt" << pnvar(L("n"),"$text") << "\n";
  return 0;
  }
L("lctxt") = strtolower(L("lctxt"));
return finddictattr(L("lctxt"),L("feat"));
}


########
# FUNC:   PHRPREPVERBQ
# SUBJ:   If possible phrasal/prepositional verb + particle.
########

phrprepverbq(L("nverb"),L("nprep"))
{
if (!L("nverb") || !L("nprep"))
  return 0;
L("tverb") = nodestem(L("nverb"));
L("tprep") = nodestem(L("nprep"));
return finddictattr(L("tverb"),L("tprep"));
}


########
# FUNC:   PHRASALVERBQ
# SUBJ:   If possible phrasal verb + particle.
########

phrasalverbq(L("nverb"),L("nprep"))
{
if (!L("nverb") || !L("nprep"))
  return 0;
L("tverb") = nodestem(L("nverb"));
L("tprep") = nodestem(L("nprep"));
L("num") = finddictattr(L("tverb"),L("tprep"));
if (L("num") == 1	# Phrasal
 || L("num") == 3)	# Both phrasal and prepositional.
 return 1;
return 0;
}

########
# FUNC:   PREPOSITIONALVERBQ
# SUBJ:   If possible prepositional verb + prep.
########

prepositionalverbq(L("nverb"),L("nprep"))
{
if (!L("nverb") || !L("nprep"))
  return 0;
L("tverb") = nodestem(L("nverb"));
L("tprep") = nodestem(L("nprep"));
L("num") = finddictattr(L("tverb"),L("tprep"));
if (L("num") == 2	# Prepositional.
 || L("num") == 3)	# Both phrasal and prepositional.
 return 1;
return 0;
}

########
# FUNC:   LJUST
# SUBJ:   Left-justify string in field.
########
ljust(L("str"),L("num"),L("out"))
{
if (!L("out"))
  return;
if (!L("str"))
  {
  indent(L("num"),L("out"));
  return;
  }
L("len") = strlength(L("str"));
L("out") << L("str");
L("diff") = L("num") - L("len");
indent(L("diff"),L("out"));
}

##############
## RJ
## SUBJ: Right justify a string etc.
##############

RJ(L("item"),L("field"))
{
if (!L("field"))
  return 0;

if (!L("item"))
  L("num") = L("field");
else
  {
  L("str") = str(L("item"));
  L("len") = strlength(L("str"));
  if (L("len") >= L("field"))
    return L("str");
  L("num") = L("field") - L("len");
  }

L("head") = " ";
--L("num");
while (L("num") > 0)
  {
  L("head") = L("head") + " ";
  --L("num");
  }
if (L("str"))
  return L("head") + L("str");
else
  return L("head");
}

########
# FUNC:   INDENT
# SUBJ:   Print padding.
########
indent(L("num"),L("out"))
{
if (!L("num") || !L("out"))
  return;
while (L("num") > 0)
  {
  L("out") << " ";
  --L("num");
  }
}

########
# FUNC:   NODECOUNT
# SUBJ:   Count nodes in a list.
# NOTE:	  NLP++ todo: could be an internal like N("$count",1)
########

nodecount(L("start"),L("end"))
{
if (!L("start"))
  return 0;

L("ii") = 0;
if (L("end"))
  L("end") = pnnext(L("end"));
while (L("start") && L("start") != L("end"))
  {
  ++L("ii");
  L("start") = pnnext(L("start"));
  }
return L("ii");
}

########
# FUNC:   NODESTEXTOUT
# SUBJ:   Get text for nodes.
########

nodestextout(
	L("start"),
	L("end"),
	L("out")
	)
{
if (!L("start") || !L("out"))
  return;
if (L("end"))
  L("end") = pnnext(L("end"));
while (L("start") && L("start") != L("end"))
  {
  L("out") << " " << nodetext(L("start"));
  L("start") = pnnext(L("start"));
  }
}

########
# FUNC:   CLAUSELASTNP
# SUBJ:   See if clause ends in np.
########
clauselastnp(L("n"))
{
if (!L("n"))
  return 0;
L("nm") = pnname(L("n"));
if (L("nm") == "_np")
  return 1;
if (L("nm") == "_advl")
  {
  if (pnvar(L("n"),"pp")) # Prepositional phrase, np at end.
    return 1;
  return 0;
  }

L("last") = pnvar(L("n"),"last");
if (L("last"))
  return clauselastnp(L("last")); # Recursive call on component.

if (L("nm") != "_clause")
  return 0;

L("p") = pnvar(L("n"),"pattern");
if (!L("p"))
  return 0;

if (L("p") == "nvn"
 || L("p") == "vn"
 || L("p") == "n"
 )
  return 1;
return 0;
}

########
# FUNC:   CLAUSEINCOMPLETE
# SUBJ:   See if clause is transitive missing object.
# NOTE:	Eg, "John threw" which doesn't occur by itself, but
#	can follow in something like "There's the ball that John threw."
########
clauseincomplete(L("n"))
{
if (!L("n"))
  return 0;

# Todo: Need knowledge of transitive and intransitive verbs.
# Todo: Issues with prep/phrasal verb patterns also.
L("p") = pnvar(L("n"),"pattern");
if (!L("p"))
  return 0;

if (L("p") == "nv"
 || L("p") == "v"
 || L("p") == "vn"	# 05/22/07 AM.
 )
  return 1;
return 0;
}

########
# FUNC:   CLAUSECOMPLETE
# SUBJ:   See if clause can be standalone.
# NOTE:	Eg, (incomplete) "John threw" which doesn't occur by itself, but
#	can follow in something like "There's the ball that John threw."
########
clausecomplete(L("n"))
{
if (!L("n"))
  return 0;

# Todo: Need knowledge of transitive and intransitive verbs.
# Todo: Issues with prep/phrasal verb patterns also.
L("p") = pnvar(L("n"),"pattern");
if (!L("p"))
  return 0;

if (L("p") == "nvn"
# || L("p") == "vn"
 || L("p") == "nvnn"
# || L("p") == "vnn"
 || L("p") == "nvj"
# || L("p") == "vj"
 )
  return 1;

if (L("p") != "nv"
 && L("p") != "v"
 )
  return 0;

# See if can be intransitive.
L("vg") = pnvar(L("n"),"vg node");
if (!L("vg"))
  return 0;
L("v") = pnvar(L("vg"),"verb node");
if (!L("v"))
  return 0;
L("stem") = nodestem(L("v"));
"cl.txt" << "clcomplete=" << L("stem") << "\n";
if (!L("stem"))
  return 0;

if (finddictattr(L("stem"),"intr"))
  return 1;

# Todo: should be copula + necessary adverbial etc.
if (copulaq(L("v")))
  return 1;

return 0;
}

########
# FUNC:   MHBVADV
# SUBJ:   Look at adverbials of mhbv phrase.
########

mhbvadv(
	L("n x1"),
	L("n x2"),
	L("n x3"),
	L("n x4")
	)
{
if (L("n x1"))
  {
  L("a") = eltnode(L("n x1"));
  L("b") = lasteltnode(L("n x1"));
  L("neg") = attrinrange("neg",L("a"),L("b"));
  if (L("neg"))
    return 1;
  }
if (L("n x2"))
  {
  L("a") = eltnode(L("n x2"));
  L("b") = lasteltnode(L("n x2"));
  L("neg") = attrinrange("neg",L("a"),L("b"));
  if (L("neg"))
    return 1;
  }
if (L("n x3"))
  {
  L("a") = eltnode(L("n x3"));
  L("b") = lasteltnode(L("n x3"));
  L("neg") = attrinrange("neg",L("a"),L("b"));
  if (L("neg"))
    return 1;
  }
if (L("n x4"))
  {
  L("a") = eltnode(L("n x4"));
  L("b") = lasteltnode(L("n x4"));
  L("neg") = attrinrange("neg",L("a"),L("b"));
  if (L("neg"))
    return 1;
  }
return 0;
}

########
# FUNC:   QCLAUSEVG
# SUBJ:   A look at a clause's verb.
########
qclausevg(L("vg"),L("clause"))
{
if (!L("vg") || !L("clause"))
  return;
if (pnname(L("vg")) != "_vg")
  return;
L("v") = pnvar(L("vg"),"verb node");
L("dn") = pndown(L("vg"));
if (L("dn") != L("v"))
  return;

# Lone verb inside its vg.
if (vconjq(L("v"),"-ing"))
  pnreplaceval(L("clause"),"ellipted-that-is",1);
}

##############
## GETANCESTOR
## SUBJ: Get a desired ancestor node.
##############

getancestor(L("n"),L("name"))
{
# Traverse up till you find it.
while (L("n"))
  {
  L("nm") = pnname(L("n"));
  if (L("nm") == L("name"))	# Found ancestor with desired name.
    return L("n");
  if (pnup(L("n")))
    L("n") = pnup(L("n"));
  else
    {
	while (L("n") && pnprev(L("n"))) # To first node in list.
	  L("n") = pnprev(L("n"));
	L("n") = pnup(L("n"));	# Up the tree.
	}
  }
return 0;
}

##############
## ALIGNNS
## SUBJ: Align node with string.
## RET:	1 if aligned with high confidence.
##############

alignNS(L("node"),L("str"))
{
if (!L("node") || !L("str"))
  return 0;

L("ntext") = nodetreetext(L("node"));
return align(L("ntext"),L("str"));
}

##############
## ALIGN
## SUBJ: Align two strings.
## RET:	1 if aligned with high confidence.
##	0 means could not align with confidence.  (Words may still
##	represent the same thing.)
##############

align(L("str1"),
	L("str")	# The "good" string being aligned to.
	)
{
if (!L("str1") || !L("str"))
  return 0;
if (G("dev")) "align.txt" << L("str1") << " <=> " << L("str") << "\n";

L("cnf") = 0;
L("thresh") = 65;	# Minimum confidence for aligned match.
L("str1") = strtolower(L("str1"));
L("str") = strtolower(L("str"));

if (L("str1") == L("str"))
  {
  if (G("dev")) "align.txt" << "  (same) MATCH" << "\n";
  return 1;
  }

# REMOVE SPACE TO "NORMALIZE".	# 09/04/09 AM.
L("str1") = strsubst(L("str1")," ",0);
L("str") = strsubst(L("str")," ",0);
if (L("str") == L("str1"))	# Equal except for spaces.
  {
  if (G("dev")) "align.txt" << "  (spacing difference) MATCH" << "\n";
  return 1;
  }

L("len1") = strlength(L("str1"));
L("len") = strlength(L("str"));
L("del") = absolute(L("len1") - L("len2"));
if (L("len1") <= 2 || L("len") <= 2)
  {
  if (G("dev")) "align.txt" << "  Too short to tell." << "\n";
  return 0;	# Can't really tell anything.
  }

# Containment.
if (L("del") <= 3 && L("len1") >= 4)
 {
 if (strcontains(L("str1"),L("str")))
  {
  if (G("dev")) "align.txt" << "  1 contained in 2. MATCH" << "\n";
  return 1;
  }
 }

# USING LEVENSHTEIN.
L("minlen") = minimum(L("len1"),L("len"));
L("lev") = levenshtein(L("str1"),L("str"));
if (!L("minlen") || L("lev") > L("minlen"))
  {
  if (G("dev")) "align.txt" << "  0%" << "\n";
  return 0;
  }
L("x") = 100.0*flt(L("minlen") - L("lev"))/flt(L("minlen"));
if (G("dev")) "align.txt" << "  lev,min,%=" << L("lev") << "," << L("minlen")
	<< "," << L("x");
if (L("x") >= L("thresh"))
  {
  if (G("dev")) "align.txt" << " MATCH" << "\n";
  return 1;
  }
if (G("dev")) "align.txt" << " NO" << "\n";
return 0;

#### IGNORING THE REST FOR NOW.....

if (L("len1") > L("len"))
  L("f") = flt(L("len1")) / flt(L("len"));
else
  L("f") = flt(L("len")) / flt(L("len1"));
if (L("f") > 1.6)
  return 0;


# Look at start and end match.
# Even if redundant letters, the order match is important.
# Todo: Longer prefix/suffix/infix for longer words.
L("pre2") = strpiece(L("str"),0,1);
L("pre1") = strpiece(L("str"),0,0);
if (strstartswith(L("str1"),L("pre2")))
  {
  if (L("len") >= 10)
    L("cnf") = L("cnf") %% 60;
  else if (L("len") >= 8)
    L("cnf") = L("cnf") %% 65;
  else if (L("len") >= 6)
    L("cnf") = L("cnf") %% 70;
  else if (L("len") == 5)
    L("cnf") = L("cnf") %% 75;
  else
  	{
    if (G("dev"))
      "align.txt" << L("str1") << ", " << L("str") << "(same start) " << L("cnf") << "\n";
    return 1;	# Good enough.
	}
  }
else if (strstartswith(L("str1"),L("pre1")))
  {
  if (L("len") >= 10)
    L("cnf") = L("cnf") %% 50;
  else if (L("len") >= 8)
    L("cnf") = L("cnf") %% 55;
  else if (L("len") >= 6)
    L("cnf") = L("cnf") %% 60;
  else if (L("len") == 5)
    L("cnf") = L("cnf") %% 65;
  else if (L("len") == 4)
    L("cnf") = L("cnf") %% 68;
  else if (L("len") == 3)
    L("cnf") = L("cnf") %% 70;
  }

L("suf3") = strpiece(L("str"),L("len")-3,L("len")-1);
L("suf2") = strpiece(L("str"),L("len")-2,L("len")-1);
L("suf1") = strpiece(L("str"),L("len")-1,L("len")-1);
if (strendswith(L("str1"),L("suf3")))
  {
  if (L("len") >= 10)
    L("cnf") = L("cnf") %% 65;
  else if (L("len") >= 8)
    L("cnf") = L("cnf") %% 70;
  else if (L("len") >= 6)
    L("cnf") = L("cnf") %% 75;
  else
    {
    if (G("dev"))
      "align.txt" << L("str1") << ", " << L("str") << "(same end) " << L("cnf") << "\n";
    return 1;	# Good enough.
	}
  }
else if (strendswith(L("str1"),L("suf2")))
  {
  if (L("len") >= 10)
    L("cnf") = L("cnf") %% 60;
  else if (L("len") >= 8)
    L("cnf") = L("cnf") %% 65;
  else if (L("len") >= 6)
    L("cnf") = L("cnf") %% 70;
  else if (L("len") == 5)
    L("cnf") = L("cnf") %% 75;
  else
    {
    if (G("dev"))
      "align.txt" << L("str1") << ", " << L("str") << "(same suff) " << L("cnf") << "\n";
    return 1;	# Good enough.
	}
  }
else if (strendswith(L("str1"),L("suf1")))
  {
  if (L("len") >= 10)
    L("cnf") = L("cnf") %% 50;
  else if (L("len") >= 8)
    L("cnf") = L("cnf") %% 55;
  else if (L("len") >= 6)
    L("cnf") = L("cnf") %% 60;
  else if (L("len") == 5)
    L("cnf") = L("cnf") %% 65;
  else if (L("len") == 4)
    L("cnf") = L("cnf") %% 68;
  else if (L("len") == 3)
    L("cnf") = L("cnf") %% 70;
  }


if (L("cnf") >= L("thresh"))
  {
  if (G("dev"))
    "align.txt" << L("str1") << ", " << L("str") << "(quick) " << L("cnf") << "\n";
  return 1;
  }

# Try a simple compositional approach.
# Assume that anagram matches are nonexistent.
L("ii") = 0;
while (L("ii") < L("len1"))
  {
  L("c") = strpiece(L("str1"),L("ii"),L("ii"));
  L("o") = letord(L("c"));
  ++L("arr1")[L("o")];
  ++L("ii");
  }

L("ii") = 0;
while (L("ii") < L("len"))
  {
  L("c") = strpiece(L("str"),L("ii"),L("ii"));
  L("o") = letord(L("c"));
  ++L("arr")[L("o")];
  ++L("ii");
  }

# Now traverse and compare.
L("ii") = 1;
L("matches") = 0;
while (L("ii") <= 26)
  {
  L("matches") = L("matches") +
    minimum(L("arr1")[L("ii")], L("arr")[L("ii")]);
  ++L("ii");
  }

L("min") = L("len");	# The one we're aligning to.
L("percent") = 100 * L("matches") / L("min");
#"align.txt" << L("str1") << " | " << L("str")
#	<< "\t" << L("matches")  << "/" << L("min") << "\n";
L("cnf") = L("cnf") %% L("percent");
if (G("dev"))
    "align.txt" << L("str1") << ", " << L("str") << " " << L("cnf") << "\n";
if (L("cnf") >= L("thresh"))
  return 1;
return 0;
}

########
# FUNC:   ARRAYMERGE
# SUBJ:   Merge two arrays.
# NOTE:	  Only copying stuff if needed.
#	Does passing an array automatically copy it?
# WARN:	CALLER MUST DECIDE IF 0 MEANS EMPTY ARRAY
#		AND ACT ACCORDINGLY.
########

arraymerge(L("arr1"),L("arr2"))
{
#if (!L("arr1"))
#  return L("arr2");
#if (!L("arr2"))
#  return L("arr1");

L("len1") = arraylength(L("arr1"));
L("len2") = arraylength(L("arr2"));
L("merge") = L("arr1");	# COPY IT.
L("ii") = 0;
while (L("ii") < L("len2"))
  {
  L("merge")[L("len1") + L("ii")] = L("arr2")[L("ii")];
  ++L("ii");
  }
return L("merge");
}

########
# FUNC:   ARRAYREVERSE
# SUBJ:   Reverse order of elements in an array.
# NOTE:	  Only copying stuff if needed.
########

arrayreverse(L("arr"))
{
if (!L("arr"))
  return 0;
L("len") = arraylength(L("arr"));
if (L("len") == 1)
  return L("arr");
L("ii") = 0;
L("jj") = L("len") - 1;
L("rev") = 0;
while (L("ii") < L("len"))
  {
  L("rev")[L("ii")] = L("arr")[L("jj")];
  ++L("ii");
  --L("jj");
  }
return L("rev");
}

########
# FUNC:   PUSH
# SUBJ:   Push value onto array.
########
push(L("val"),L("arr"))
{
if (!L("arr"))
  return L("val");
L("len") = arraylength(L("arr"));
L("newarr")[0] = L("val");
L("ii") = 0;
while (L("ii") < L("len"))
  {
  L("newarr")[L("ii")+1] = L("arr")[L("ii")];
  ++L("ii");
  }
return L("newarr");
}

########
# FUNC:   RPUSH
# SUBJ:   Push value onto array end of array.
########

rpush(L("arr"),L("val"))
{
if (!L("arr"))
  return L("val");
L("len") = arraylength(L("arr"));
L("arr")[L("len")] = L("val");
return L("arr");
}
########
# FUNC:   PUSHZ
# SUBJ:   Push value onto array.
# NOTE:	 Treats zero as an array with one value.
########
pushz(L("val"),L("arr"))
{
#if (!L("arr"))
#  return L("val");
L("len") = arraylength(L("arr"));
L("newarr")[0] = L("val");
L("ii") = 0;
while (L("ii") < L("len"))
  {
  L("newarr")[L("ii")+1] = L("arr")[L("ii")];
  ++L("ii");
  }
return L("newarr");
}

########
# FUNC:   RPUSHZ
# SUBJ:   Push value onto array end of array.
# NOTE:	 Treats zero as an array with one value.
########

rpushz(L("arr"),L("val"))
{
#if (!L("arr"))
#  return L("val");
L("len") = arraylength(L("arr"));
L("arr")[L("len")] = L("val");
return L("arr");
}

######## PRINTCH
# SUBJ: Print given number of chars.
###################
printch(L("ch"),L("num"),L("out"))
{
if (!L("ch") || !L("num") || !L("out"))
  return;
while (L("num") > 0)
  {
  L("out") << L("ch");
  --L("num");
  }
}

######## RJX
# SUBJ: Right-justify something to print.
###################
rjx(
	L("item"),	# Item to print.
	L("field"),	# Length of field to print in.
	L("ch"),	# Leading char.
	L("out")
	)
{
if (!L("field") || !L("out"))
  return;
if (!L("ch"))
  L("ch") = " "; # Default is space.

L("str") = str(L("item"));  # Must be forced to string.
L("len") = strlength(L("str"));
L("ii") = L("field") - L("len");
while (L("ii") > 0)
  {
  L("out") << L("ch");
  --L("ii");
  }
L("out") << L("str");
}

######## CTR
# SUBJ: Pretty-print centered in a field.
###################
ctr(
	L("item"),	# Item to print.
	L("field"),	# Length of field to print in.
	L("ch"),	# Surrounding chars.
	L("out")
	)
{
if (!L("field") || !L("out"))
  return;
if (!L("ch"))
  L("ch") = " "; # Default is space.

L("str") = str(L("item"));  # Must be forced to string.
L("len") = strlength(L("str"));

# Figure out preceding chars.
L("pad") = L("field") - L("len");
L("pre") = L("pad")/2;
L("post") = L("pad") - L("pre");

L("ii") = L("pre");
while (L("ii") > 0)
  {
  L("out") << L("ch");
  --L("ii");
  }
L("out") << L("str");

if (!L("post"))
  return;
if (L("ch") == " ")
  return;

L("ii") = L("post");
while (L("ii") > 0)
  {
  L("out") << L("ch");
  --L("ii");
  }
}

########
# FUNC:   PNFINDCHILD
# SUBJ:   Find child node by name.
# NOTE:	  Fetch the first one found.
########
pnfindchild(L("n"),L("name"))
{
if (!L("n") || !L("name"))
  return 0;
L("n") = pndown(L("n"));
if (!L("n"))
  return 0;
while (L("n"))
  {
  if (L("name") == pnname(L("n")))
    return L("n");
  L("n") = pnnext(L("n"));
  }
return 0;
}

########
# FUNC:   KBCHILDRENTOARRAY
# SUBJ:   Copy kb children to an array.
# RET:	  Array.
########

kbchildrentoarray(
	L("parent")	# Parent concept.
	)
{
if (!L("parent"))
  return 0;
L("n") = down(L("parent"));
L("arr") = 0;
L("ii") = 0;
while (L("n"))
  {
  L("arr")[L("ii")] = L("n");
  ++L("ii");
  L("n") = next(L("n"));
  }
return L("arr");
}


##############
## LETORD
## RET: Return 1 for "a", 2 for "b", etc. 0 for non-alpha.
## ASS:	Lowercase alphabetic letter.
##############

letord(L("c"))
{
if (L("c") == "a")
	return 1;
if (L("c") == "b")
	return 2;
if (L("c") == "c")
	return 3;
if (L("c") == "d")
	return 4;
if (L("c") == "e")
	return 5;
if (L("c") == "f")
	return 6;
if (L("c") == "g")
	return 7;
if (L("c") == "h")
	return 8;
if (L("c") == "i")
	return 9;
if (L("c") == "j")
	return 10;
if (L("c") == "k")
	return 11;
if (L("c") == "l")
	return 12;
if (L("c") == "m")
	return 13;
if (L("c") == "n")
	return 14;
if (L("c") == "o")
	return 15;
if (L("c") == "p")
	return 16;
if (L("c") == "q")
	return 17;
if (L("c") == "r")
	return 18;
if (L("c") == "s")
	return 19;
if (L("c") == "t")
	return 20;
if (L("c") == "u")
	return 21;
if (L("c") == "v")
	return 22;
if (L("c") == "w")
	return 23;
if (L("c") == "x")
	return 24;
if (L("c") == "y")
	return 25;
if (L("c") == "z")
	return 26;
return 0;
}


##############
## RANGEFEAT
## SUBJ:	Check range of nodes for occurrences of a feature.
## RET: 1 if range of nodes has needed feature occurrences.
##############

rangefeat(
	L("start"),	# First node.
	L("end"),	# Last node.
	L("feat"),	# Name of feature.
	L("min")	# Minimum required occurrences for success.
	)
{
if (!L("start") || !L("end") || !L("feat"))
  return 0;
if (L("end"))
  L("end") = pnnext(L("end"));	# Right bound.
L("n") = L("start");
L("count") = 0;
while (L("n") && L("n") != L("end"))
  {
  if (pnvar(L("n"),L("feat")))
    ++L("count");
  L("n") = pnnext(L("n"));
  }
if (L("count") >= L("min"))
  return 1;
return 0;
}


##############
## RANGEFEATCOUNT
## SUBJ:	Count occurrences of feature in range of nodes.
## RET:		num = count of nodes that have the feature.
## NOTE:	For example, how many nodes in range have "neg"
##			or negation.
##############

rangefeatcount(
	L("start"),	# First node.
	L("end"),	# Last node.
	L("feat")	# Name of feature.
	)
{
if (!L("start") || !L("end") || !L("feat"))
  return 0;
if (L("end"))
  L("end") = pnnext(L("end"));	# Right bound.
L("n") = L("start");
L("count") = 0;
while (L("n") && L("n") != L("end"))
  {
  if (pnvar(L("n"),L("feat")))
    ++L("count");
  L("n") = pnnext(L("n"));
  }
return L("count");
}


##############
## PNCHILDSFEATCOUNT
## SUBJ:	Count occurrences of feature in node's children.
## RET:		num = count of nodes that have the feature.
## NOTE:	For example, how many nodes in range have "neg"
##			or negation.
##############

pnchildsfeatcount(
	L("node"),	# Node whose children we traverse.
	L("feat")	# Name of feature.
	)
{
if (!L("node") || !L("feat"))
  return 0;
L("n") = pndown(L("node"));
L("count") = 0;
while (L("n"))
  {
  if (pnvar(L("n"),L("feat")))
    ++L("count");
  L("n") = pnnext(L("n"));
  }
return L("count");
}


##############
## ARRAYOUT
## SUBJ: Print an array on a line.
## RET:	
## KEY:	printarray(), printarr()
##############

arrayout(
	L("arr"),
	L("out"),
	L("sep") # Separator char.
	)
{
if (!L("arr") || !L("out"))
  return;

if (!L("sep"))
  {
  # Use the default, separate by whitespace char.
  L("out") << L("arr");
  return;
  }

L("len") = arraylength(L("arr"));
if (L("len") <= 0)
  return;

L("out") << L("arr")[0];
L("ii") = 1;
while (L("ii") < L("len"))
  {
  L("out") << L("sep") << L("arr")[L("ii")];
  ++L("ii");
  }
}


##############
## STRDEPUNCT
## SUBJ: Remove punctuation from a string.
## RET:	
## NOTE: Should be an NLP++ function.
##############

strdepunct(L("str"))
{
if (!L("str"))
  return 0;
#"depx.txt" << L("str") << "   <=>   ";
L("str") = strsubst(L("str"),"'"," ");
L("str") = strsubst(L("str"),"�"," ");	# 03/04/13 AM.
L("str") = strsubst(L("str"),"."," ");
L("str") = strsubst(L("str"),"-"," ");
L("str") = strsubst(L("str"),"_"," ");
L("str") = strsubst(L("str"),"#"," ");
L("str") = strsubst(L("str"),","," ");
L("str") = strsubst(L("str"),"("," ");
L("str") = strsubst(L("str"),")"," ");
L("str") = strsubst(L("str"),"/"," ");
L("str") = strsubst(L("str"),"\"",0);	# 03/04/13 AM.
L("str") = strclean(L("str"));
#"depx.txt" << L("str") << "\n";
return L("str");
}

##############
## LEFTATTR
## SUBJ: Look in parse subtree for leftmost node's attr.
## RET:	Value of leftmost node's attr.
##############

leftattr(
	L("n"),	# Root of subtree.
	L("attr")	# Name of attribute.
	)
{
if (!L("attr"))
  return 0;
L("val") = 0;
while (L("n") && !L("val"))
  {
  L("val") = pnvar(L("n"),L("attr"));
  L("n") = pndown(L("n"));
  }
return L("val");
}

##############
## RIGHTATTR
## SUBJ: Look in parse subtree for rightmost node's attr.
## RET:	Value of rightmost node's attr.
##############

rightattr(
	L("n"),	# Root of subtree.
	L("attr")	# Name of attribute.
	)
{
if (!L("n") || !L("attr"))
  return 0;
L("val") = pnvar(L("n"),L("attr"));
if (L("val"))
  return L("val");
L("n") = pndown(L("n"));

while (L("n") && !L("val"))
  {
  # Get rightmost node in chain.
  while (L("n"))
    {
	L("last") = L("n");
	L("n") = pnnext(L("n"));
	}
  L("val") = pnvar(L("last"),L("attr"));
  L("n") = pndown(L("last"));
  }
return L("val");
}

##############
## GETPOSITION
## SUBJ: Get position of a value in an array.
## RET:	position in given array, 0 based.
## NOTE: Assume an array of unique values.  Find the first match.
##############

getposition(
	L("ii"),    # Positive integer.
	L("arr")	# Array
	)
{
if (!L("ii") || !L("arr"))
  return 0;

L("jj") = 0;
while (!L("done"))
  {
  L("val") = L("arr")[L("jj")];
  if (L("val") == L("ii"))
    return L("jj");
  if (!L("val"))
    return 0;
  ++L("jj");
  }
return 0;
}

##############
## ALPHACHARS
## SUBJ: Count alpha chars in a string.
## RET:	count.
## OPT:	Highly inefficient.
##############

alphachars(L("str"))
{
if (!L("str"))
  return 0;
L("len") = strlength(L("str"));
while (L("ii") < L("len"))
  {
  L("ch") = strpiece(L("str"),L("ii"),L("ii"));
  if (strisalpha(L("ch")))
    ++L("chars");
  ++L("ii");
  }
return L("chars");
}

##############
## INITIALS
## SUBJ: Get initials of each word in given string.
## RET: initials = string of initials, separated by space.
## NOTE: Eg, "John Smith" => returns "J S".
##	May want an option for no space in returned string.
##############

initials(L("str"))
{
if (!L("str"))
  return 0;

L("x") = split(L("str")," ");
L("len") = arraylength(L("x"));
L("inits") = strpiece(L("x")[0],0,0);
++L("ii");
while (L("ii") < L("len"))
  {
  L("inits") = L("inits") + " " + strpiece(L("x")[L("ii")],0,0);
  ++L("ii");
  }
return L("inits");
}

##############
## PERCENTRND
## SUBJ: Percent rounded to n decimal places.
## RET: string.
## EX:	100%,  96.1%
##############

percentrnd(
	L("top"),	# Numerator
	L("bot"),	# Denominator
	L("n")		# Decimal places
	)
{
# Handle one place only, for now.
L("n") = 1;

if (!L("top") || !L("bot"))
  return "   0%";
if (L("top") >= L("bot"))
  return " 100% ";

L("pct") = 100.0 * L("top") / L("bot");
L("h") = num(L("pct"));
L("d") = L("pct") - L("h");

#if (L("h") < 10)
#  L("hs") = " " + str(L("h"));
#else
#  L("hs") = str(L("h"));

L("ds") = str(L("d"));
L("len") = strlength(L("ds"));
# Get rid of 0. part.
L("ds") = strpiece(L("ds"),2,L("len")-1);
L("len") = L("len") - 2;

L("ii") = L("len") - 1;
L("inc") = 0;	# Whether to increment current digit.
while (L("ii") > 0)
  {
  L("ch") = strpiece(L("ds"),L("ii"),L("ii"));
  L("cn") = num(L("ch"));
  if (L("inc"))
    ++L("cn");
  if (L("cn") >= 10)
    {
	L("cn") = 0;
	L("inc") = 1;
	}
  else if (L("cn") >= 5)
    L("inc") = 1;
  else
    L("inc") = 0;
  L("ch") = str(L("cn"));	# Convert rounded digit.
  
  if (L("ii") == L("n"))	# Got number of places.
    {
	# Compute and return.
	if (L("n") == 1 && L("ch") == "0" && L("inc"))
	  {
	  # Increment the whole number.
	  ++L("h");
	  if (L("h") >= 100)
	    return "100% ";
	  if (L("h") >= 10)
	    return " " + str(L("h")) + ".0%";
	  return str(L("h")) + ".0%";
	  }
	if (L("n") == 1)
	  {
	  if (L("h") < 10)
	    return " " + str(L("h")) + "." + L("ch") + "%";
	  return str(L("h")) + "." + L("ch") + "%";
	  }
	return "0";  # Not handled.
	}
  --L("ii");
  }
return str(L("pct"));
}

###########################################################
### THREENORM
# Subj:	Normalize a numeric string to three or more places.
#	Add leading zeros as needed.
###########################################################
threenorm(L("str"))
{
if (!L("str"))
  return 0;
L("len") = strlength(L("str"));
if (L("len") == 0)
  return 0;
if (L("len") == 1)
  return "00" + L("str");
if (L("len") == 2)
  return "0" + L("str");
return L("str");
}

###########################################################
### TWONORM
# Subj:	Normalize a numeric string to two or more places.
#	Add leading zeros as needed.
###########################################################

twonorm(L("str"))
{
if (!L("str"))
  return 0;
L("len") = strlength(L("str"));
if (L("len") == 0)
  return 0;
if (L("len") == 1)
  return "0" + L("str");
return L("str");
}


###########################################################
### PAD
# Subj:	Create a padded string for given string, to fill out to given places.
#	CR:	06/30/16 AM.
###########################################################

PAD(
	L("str"),	# Given string to fill out.
	L("places"), # Number of places to fill out to.
	L("ch")		# Character to use in filling.
	)
{
if (!L("places") || !L("ch")) return 0;
if (L("places") > 100) return 0;	# Too much nonsense.

if (!L("str"))
  L("len") = 0;
else
  L("len") = strlength(L("str"));

while (L("len") < L("places"))
  {
  L("ss") = L("ch") + L("ss");
  ++L("len");
  }
return L("ss");
}

###########################################################
### CONVALS
# SUBJ:	Fetch a multi-valued con attribute from kb, as array.
# RET:	arr - array of found values.
# NOTE:	valstoarray, arrayfromvals...
###########################################################

convals(
	L("con"),	# Concept to look in.
	L("key")	# Attribute key.
	)
{
if (!L("con") || !L("key"))
  return 0;
if (!(L("attr") = findattr(L("con"),L("key"))))
  return 0;
if (!(L("val") = attrvals(L("attr"))))
  return 0;

L("cons") = 0;	# Build array of cons.
L("ii") = 0;	# Count for array.
while (L("val"))
  {
  if (L("c") = getconval(L("val")))
    {
	L("cons")[L("ii")] = L("c");
	++L("ii");
	}
  L("val") = nextval(L("val"));
  }
return L("cons");
}
###########################################################
### STRVALS
# SUBJ:	Fetch a multi-valued string attribute from kb, as array.
# RET:	arr - array of found values.
# NOTE:	valstoarray, arrayfromvals...
###########################################################

strvals(
	L("con"),	# Concept to look in.
	L("key")	# Attribute key.
	)
{
if (!L("con") || !L("key"))
  return 0;
if (!(L("attr") = findattr(L("con"),L("key"))))
  return 0;
if (!(L("val") = attrvals(L("attr"))))
  return 0;

L("cons") = 0;	# Build array of cons.
L("ii") = 0;	# Count for array.
while (L("val"))
  {
  if (L("c") = getstrval(L("val")))
    {
	L("cons")[L("ii")] = L("c");
	++L("ii");
	}
  L("val") = nextval(L("val"));
  }
return L("cons");
}


###########################################################
### CONVALSMAX
# SUBJ:	Fetch a multi-valued attribute from kb, as array.
# RET:	arr - array of found values.
# NOTE:	If number of values > max, return 0.
###########################################################

convalsmax(
	L("con"),	# Concept to look in.
	L("key"),	# Attribute key.
	L("max")	# Maximum number of allowed values.
	)
{
if (!L("con") || !L("key"))
  return 0;
if (!(L("attr") = findattr(L("con"),L("key"))))
  return 0;
if (!(L("val") = attrvals(L("attr"))))
  return 0;

L("cons") = 0;	# Build array of cons.
L("ii") = 0;	# Count for array.
while (L("val"))
  {
  if (L("c") = getconval(L("val")))
    {
	L("cons")[L("ii")] = L("c");
	++L("ii");
	}
  L("val") = nextval(L("val"));
  }

if (L("ii") > L("max"))
  L("cons") = 0;
return L("cons");
}



###########################################################
### NAMESTOLIST
# SUBJ:	Convert list of name nodes to unique word array.
# RET:	arr - array of unique name words.
###########################################################

namestolist(
	L("pns"),	# Array of nodes.
	L("count")	# Array length.
	)
{
if (!L("pns") || !L("count"))
  return 0;

L("ii") = 0;
L("names") = 0;
while (L("ii") < L("count"))
  {
  L("n") = L("pns")[L("ii")];
  L("last") = pnvar(L("n"),"lastname text");
  if (L("last"))
    L("last") = strtolower(L("last"));
  L("names") = qaddstr(L("last"),L("names"));
  L("first") = pnvar(L("n"),"firstname text");
  if (L("first"))
    L("first") = strtolower(L("first"));
  L("names") = qaddstr(L("first"),L("names"));
  L("mid") = pnvar(L("n"),"middlename text");
  if (L("mid"))
    L("mid") = strtolower(L("mid"));
  L("names") = qaddstr(L("mid"),L("names"));
  ++L("ii");
  }
return L("names");
}


###########################################################
### UNIONCONS
# SUBJ:	Do a union of two arrays of concepts.
# RET:	arr - array of unique values.
# NOTE:	Not assuming that either of the arrays is unique values.
# OPT:	O(n-square)
###########################################################

unioncons(
	L("c1"),
	L("c2")
	)
{
if (!L("c1") && !L("c2"))
  return 0;

L("arr") = 0;	# New array.

# Build array from first.
L("len") = 0;
if (L("c1"))
  L("len") = arraylength(L("c1"));
L("ii") = 0;
while (L("ii") < L("len"))
  {
  L("c") = L("c1")[L("ii")];
  L("arr") = qaddvalue(L("c"),L("arr"));
  ++L("ii");
  }

# Build array from second.
L("len") = 0;
if (L("c2"))
  L("len") = arraylength(L("c2"));
L("ii") = 0;
while (L("ii") < L("len"))
  {
  L("c") = L("c2")[L("ii")];
  L("arr") = qaddvalue(L("c"),L("arr"));
  ++L("ii");
  }

return L("arr");
}

########
# FUNC:	INTERSECT
# SUBJ:	Intersection of two string-valued arrays.
# RET:	Array representing intersection.
# NOTE:	Caller should make sure arrays are DEDUP'ed.
########
intersect(L("arr1"),L("arr2"))
{
if (!L("arr1") || !L("arr2"))
  return 0;
#L("arr1") = dedup(L("arr1"));
#L("arr2") = dedup(L("arr2"));
L("len1") = arraylength(L("arr1"));
#L("len2") = arraylength(L("arr2"));
L("ii") = 0;
L("newarr") = 0;
L("len") = 0; # Length of new array.
while (L("ii") < L("len1"))
  {
  L("val") = L("arr1")[L("ii")];
  if (valinarray(L("val"),L("arr2")))
	  {
	  L("newarr")[L("len")] = L("val");	# Add new val.
	  ++L("len");
	  }
  ++L("ii");
  }
return L("newarr");
}

###########################################################
### INTERSECTCOUNT
# SUBJ:	Count intersecting values in two arrays.
# RET:	num = number of matches.
# NOTE:	Ignoring any redundant value issues.
###########################################################

intersectcount(
	L("a1"),
	L("a2")
	)
{
if (!L("a1") || !L("a2"))
  return 0;

L("len1") = arraylength(L("a1"));
L("ii") = 0;
while (L("ii") < L("len1"))
  {
  L("e") = L("a1")[L("ii")];
  if (valinarray(L("e"),L("a2")))
    ++L("matches");
  ++L("ii");
  }
return L("matches");
}

########
# FUNC:	UNIONX
# SUBJ:	Union of two string-valued arrays.
# RET:	Array representing union.
# NOTE:	Caller should make sure arrays are DEDUP'ed.
# WARN:	Compiling the word UNION conflicts with C++ type name.
########

unionx(L("arr1"),L("arr2"))
{
if (!L("arr1"))
  return L("arr2");
if (!L("arr2"))
  return L("arr1");

L("len1") = arraylength(L("arr1"));
L("len2") = arraylength(L("arr2"));
L("union") = L("arr1");	# COPY one array.

L("ii") = 0;
while (L("ii") < L("len2"))
  {
  L("val") = L("arr2")[L("ii")];
  if (!valinarray(L("val"),L("union")))
    {
	# Add to union.
	L("union")[L("len1")] = L("val");
	++L("len1");
	}
  ++L("ii");
  }
return L("union");
}

########
# FUNC:	DEDUP
# SUBJ:	Remove duplicate values from an array.
# RET:	Uniqued array.
########

dedup(L("arr"))
{
if (!L("arr"))
  return 0;
L("len") = arraylength(L("arr"));
if (L("len") == 1)
  return L("arr");
L("dedup") = L("arr")[0];
L("len1") = 1;
L("ii") = 1;
while (L("ii") < L("len"))
  {
  L("val") = L("arr")[L("ii")];
  if (!valinarray(L("val"),L("dedup")))
    {
	# Add to array.
	L("dedup")[L("len1")] = L("val");
	++L("len1");
	}
  ++L("ii");
  }
return L("dedup");
}

###########################################################
### VALINARRAY
# SUBJ:	See if value is in array.
# RET:	1 if found, else 0.
###########################################################

valinarray(
	L("val"),
	L("arr")
	)
{
if (!L("val") || !L("arr"))
  return 0;
L("len") = arraylength(L("arr"));
while (L("ii") < L("len"))
  {
  L("e") = L("arr")[L("ii")];
  if (L("e") == L("val"))
    return 1;
  ++L("ii");
  }
return 0;
}


############# KB FUNS

###########################################################
### CWORDS
# SUBJ:	Build string from kb attribute having word concepts.
###########################################################

cwords(
	L("con"),	# Concept
	L("key")	# Attribute name.
	)
{
if (!L("con") || !L("key"))
  return 0;

L("attr") = findattr(L("con"),L("key"));
if (!L("attr"))
  return 0;

L("val") = attrvals(L("attr"));

# If there are attribute values, build string.
L("str") = 0;
while (L("val"))
  {
  L("c") = getconval(L("val"));	# Word concept.
  if (L("str"))
    L("str") = L("str") + " " + conceptname(L("c"));
  else
    L("str") = conceptname(L("c"));
  L("val") = nextval(L("val"));
  }
return L("str");
}

###########################################################
### WORDSTODICT
# SUBJ:	Build array of dict concepts for array of words.
# RET:	Array of dict concepts.
###########################################################

wordstodict(L("words"))
{
if (!L("words"))
  return 0;
L("len") = arraylength(L("words"));
while (L("ii") < L("len"))
  {
  L("w") = L("words")[L("ii")];
  if (L("w"))
    L("c") = dictfindword(L("w"));
  else
    L("c") = 0;
  L("arr")[L("ii")] = L("c");
  ++L("ii");
  }
return L("arr");
}


###########################################################
### WORDSTOCONVALS
# SUBJ:	Build unique array of concept values from word lookup.
###########################################################

wordstoconvals(
	L("words"),	# Array of words.
	L("key")	# Attribute key to lookup.
	)
{
if (!L("words") || !L("key"))
  return 0;
L("len") = arraylength(L("words"));
L("ii") = 0;
L("cons") = 0;
#if (G("dev")) "xxx.txt" << "wordstoconvals: len=" << L("len") << "\n";
while (L("ii") < L("len"))
  {
  L("w") = strtolower(L("words")[L("ii")]);
  L("c") = dictfindword(L("w"));
#  if (L("c"))
#    if (G("dev")) "xxx.txt" << "got word=" << L("w") << "\n";
  L("vs") = convalsmax(L("c"),L("key"),9);
  L("cons") = unioncons(L("cons"),L("vs"));
  ++L("ii");
  }
return L("cons");
}


###########################################################
### UPDATEARRAY
# Subj:	Catenate two arrays and return result.
# NOTE:	Assume nonempty values.
###########################################################

updatearray(L("arr1"),L("arr2"))
{
if (!L("arr2"))
  return L("arr1");
if (!L("arr1"))
  return L("arr2");

L("len1") = arraylength(L("arr1"));
L("len2") = arraylength(L("arr2"));
L("ii") = L("len1");
L("jj") = 0;
while (L("jj") < L("len2"))
  {
  # Add value.
  # OPT: Needs optimization.
  L("arr1")[L("ii")] = L("arr2")[L("jj")];
  ++L("ii");
  ++L("jj");
  }
return L("arr1");
}

###########################################################
### PNRPUSHUNIQ
# Subj:	Push values onto node variable, assure unique values.
# RET:	1 if ok.
# NOTE:	Assume nonempty values.
#	Adds only if unique.
#	concatenate arrays, merge arrays, fuse arrays.
#	union of arrays. (NOT intersection).
# OPT:	# 12/17/14 AM.
# NLP++:	Should be a built-in function.
###########################################################

pnrpushuniq(L("n"),L("key"),L("arr"))
{
if (!L("n") || !L("key")) return 0;
if (!L("arr")) return 1;

L("len") = arraylength(L("arr"));
L("ii") = 0;
while (L("vv") = L("arr")[L("ii")])
  {
#  "xxxx.txt" << pnvar(L("n"),L("key")) << "\n";
#  "xxxx.txt" << "val=" << L("vv") << "\n";
  if (!valinarray(L("vv"),pnvar(L("n"),L("key")) ) ) # If not redundant.  # FIX. # 12/19/14 AM.
    pnrpushval(L("n"),L("key"),L("vv"));
	# FIX.	# 12/22/14 AM.
  ++L("ii");
  }
return L("arr1");
}

###########################################################
### UPDATEARRAYUNIQ
# Subj:	Catenate two arrays and return result.
# NOTE:	Assume nonempty values.
#	Adds only if unique.
#	concatenate arrays, merge arrays, fuse arrays.
#	union of arrays. (NOT intersection).
# OPT:	See pnpushuniq	# 12/17/14 AM.
###########################################################

updatearrayuniq(L("arr1"),L("arr2"))
{
if (!L("arr2"))
  return L("arr1");
if (!L("arr1"))
  return L("arr2");

L("len1") = arraylength(L("arr1"));
L("len2") = arraylength(L("arr2"));
L("ii") = L("len1");
L("jj") = 0;
while (L("jj") < L("len2"))
  {
  # OPT: Needs optimization.
  L("v") = L("arr2")[L("jj")];
  if (L("v") && !valinarray(L("v"),L("arr1")) ) # If not redundant.
    {
    L("arr1")[L("ii")] = L("arr2")[L("jj")];
    ++L("ii");
    }
  ++L("jj");
  }
return L("arr1");
}

###########################################################
### XFEREARRAY
# Subj:	Update array from one node to another.
# NOTE:	Assume nonempty values.
# RET:	arr - the merged array.
###########################################################

xferarray(
	L("to"),	# Node to merge to.
	L("field"),	# Field to merge to.
	L("arr")	# Array to add in.
	)
{
if (!L("to"))
  return 0;


L("x") = pnvar(L("to"),L("field"));

if (!L("field") || !L("arr"))
  return L("x");

pnreplaceval(L("to"),L("field"),
	updatearray(L("x"),L("arr")) );
L("x") = pnvar(L("to"),L("field"));
return L("x");
}

###########################################################
### XFEREARRAYUNIQ
# Subj:	Update array from one node to another.
# NOTE:	Assume nonempty values.
#	ADD IF UNIQUE VALUES.
# OLD: RET:	arr - the merged array.
# RET: [OPT] 1 if ok, else 0.
# OPT: Caller can fetch from the node if needs the array.	# 12/17/14 AM.
###########################################################

xferarrayuniq(
	L("to"),	# Node to merge to.
	L("field"),	# Field to merge to.
	L("arr")	# Array to add in.
	)
{
if (!L("to"))
  return 0;


L("x") = pnvar(L("to"),L("field"));

if (!L("field") || !L("arr"))
  return 1;	# Already there.	# 12/17/14 AM.

pnreplaceval(L("to"),L("field"),updatearrayuniq(L("x"),L("arr")) );
#L("x") = pnvar(L("to"),L("field"));
#return L("x");
return 1;	# [OPT]	# 12/17/14 AM.
}

##############
## CONVERTWORDNUM
## SUBJ: Get numeric value of a "number word".
## RET:	int.
##############

convertwordnum(
	L("str")	# Single word for now.
	)
{
if (!L("str"))
  return 0;  # what about "ZERO".
L("str") = str(L("str"));	# Make sure it's a string.
L("str") = strtolower(L("str"));
if (L("str") == "one")
  return 1;
if (L("str") == "two")
  return 2;
if (L("str") == "three")
  return 3;
if (L("str") == "four")
  return 4;
if (L("str") == "five")
  return 5;
if (L("str") == "six")
  return 6;
if (L("str") == "seven")
  return 7;
if (L("str") == "eight")
  return 8;
if (L("str") == "nine")
  return 9;
if (L("str") == "ten")
  return 10;
if (L("str") == "eleven")
  return 11;
if (L("str") == "twelve")
  return 12;
if (L("str") == "thirteen")
  return 13;
if (L("str") == "fourteen")
  return 14;
if (L("str") == "fifteen")
  return 15;
if (L("str") == "sixteen")
  return 16;
if (L("str") == "seventeen")
  return 17;
if (L("str") == "eighteen")
  return 18;
if (L("str") == "nineteen")
  return 19;
if (L("str") == "twenty")
  return 20;
if (L("str") == "thirty")
  return 30;
if (L("str") == "forty")
  return 40;
if (L("str") == "fifty")
  return 50;
if (L("str") == "sixty")
  return 60;
if (L("str") == "seventy")
  return 70;
if (L("str") == "eighty")
  return 80;
if (L("str") == "ninety")
  return 90;
if (L("str") == "hundred")
  return 100;
if (L("str") == "thousand")
  return 1000;
if (L("str") == "million")
  return 100000;
return 0;
}

###########################################################
### NODEARRAYADD
# SUBJ:	Add a value to an array in a node.
# NOTE:	Convenience function.
###########################################################

nodearrayadd(
	L("node"),
	L("nm"),	# Name of array variable.
	L("len"),	# Length of array.
	L("val")	# Value to add at end.
	)
{
if (!L("node") || !L("nm"))
  return;
L("arr") = pnvar(L("node"),L("nm"));
L("arr")[L("len")] = L("val");
pnreplaceval(L("node"),L("nm"),L("arr"));
}


##############
## NODEARRAYADDUNIQ
## SUBJ: Add one value to an array on a node.
## RET:	
## LIKE pnaddval(), pnaddvaluniq().
## NLP++:	NEED PROPER NLP++ FUNCTION FOR THIS.
##############

nodearrayadduniq(
	L("x"),	# Node with array.
	L("field"),	# Name of array variable.
	L("val")
	)
{
if (!L("x") || !L("field") || !L("val"))
  return;

L("arr") = pnvar(L("x"),L("field"));
if (!L("arr"))	# Var not there yet.
  {
  pnreplaceval(L("x"),L("field"),L("val"));
  return;
  }

# Traverse array to the end.
# If value not already present, add it.
L("ii") = 0;
while (L("v") = L("arr")[L("ii")] )
  {
  if (L("v") == L("val"))
    return;	# Found matching value.
  ++L("ii");
  }
# Reached end, didn't find matching value.
L("arr")[L("ii")] = L("val");

# Place array back into node.
pnreplaceval(L("x"),L("field"),L("arr"));
}


###########################################################
### CLEANTEXT
# Subj:	Clean extra space etc.
###########################################################

cleantext(L("str"))
{
if (!L("str"))
  return 0;
L("str") = strsubst(L("str"),"\""," ");
L("str") = strsubst(L("str"),","," ");
L("str") = strsubst(L("str"),"    "," ");
L("str") = strsubst(L("str"),"   "," ");
L("str") = strsubst(L("str"),"  "," ");
return L("str");
}


##############
## ROMANTONUM
## RET: Return 1 for "I", 2 for "II", etc. 0 for non-roman.
##############
romantonum(
	L("str")	# Roman numberal.
	)
{
if (!L("str"))
  return 0;	#
L("str") = str(L("str"));	# Make sure it's a string.
L("str") = strtoupper(L("str"));
if (L("str") == "I")
  return 1;
if (L("str") == "II")
  return 2;
if (L("str") == "III")
  return 3;
if (L("str") == "IV")
  return 4;
if (L("str") == "V")
  return 5;
if (L("str") == "VI")
  return 6;
if (L("str") == "VII")
  return 7;
if (L("str") == "VIII")
  return 8;
if (L("str") == "IX")
  return 9;
if (L("str") == "X")
  return 10;
if (L("str") == "XI")
  return 11;
if (L("str") == "XII")
  return 12;
if (L("str") == "XIII")
  return 13;
if (L("str") == "XIV")
  return 14;
if (L("str") == "XV")
  return 15;
if (L("str") == "XVI")
  return 16;
if (L("str") == "XVII")
  return 17;
if (L("str") == "XVIII")
  return 18;
if (L("str") == "XIX")
  return 19;
if (L("str") == "XX")
  return 20;
if (L("str") == "XXX")
  return 30;
if (L("str") == "XL")
  return 40;
if (L("str") == "L")
  return 50;
if (L("str") == "LX")
  return 60;
if (L("str") == "LXX")
  return 70;
if (L("str") == "LXXX")
  return 80;
if (L("str") == "XC")
  return 90;
if (L("str") == "C")
  return 100;
if (L("str") == "M")
  return 1000;
return 0;
}


########
# FUNC:   CONCEPTPATHARRAY
# SUBJ:   Build array for a concept's path.
# CR:     08/22/19 AM.
# NOTE:	  For finding meeting point of two concept paths, etc.
########

conceptpatharray(L("cc"))
{
if (!L("cc")) return 0;
L("arr")[0] = L("cc");
L("ii") = 0;	# Index.
while (L("cc") = up(L("cc")) )
  {
  L("arr")[++L("ii")] = L("cc");
  }
return L("arr");
}


########
# FUNC:   MATCHARRAYS
# SUBJ:   Traverse arrays till elements don't match.
# CR:     08/22/19 AM.
# NOTE:	  For finding meeting point of two concept paths, etc.
########

matcharrays(L("aa1"),L("aa2"))
{
if (!L("aa1") || !L("aa2")) return 0;
# Traverse.
while (!L("done"))
  {
  L("aa") = L("aa1")[L("ii")];
  if (!L("aa")) return L("mm");	# DONE.
  L("bb") = L("aa2")[L("ii")];
  if (!L("bb")) return L("mm"); # DONE.
  if (L("aa") == L("bb"))
    {
	L("mm") = L("aa");	# MATCHED ELEMENT.
	++L("ii");
	}
  else
    return L("mm");	# DONE.
  }
return L("mm");
}


########
# FUNC:   INHIERARCHY
# SUBJ:   See if given concept is under a concept by name.
# CR:     06/26/02 AM.
########

inhierarchy(L("con"),L("parent_str"))
{
if (!L("parent_str"))
  return 0; # false.
while (L("con"))
  {
  if (conceptname(L("con")) == L("parent_str"))
    return 1; # true.
  L("con") = up(L("con"));
  }
return 0; # false.
}


########
# FUNC:   INHIER
# SUBJ:   See if given concept is under a concept.
########

inhier(L("con"),L("parent_con"))
{
#"hier.txt" << "inhier:" << "\n";
if (!L("con") || !L("parent_con"))
  return 0; # false.
while (L("con"))
  {
#  "hier.txt" << conceptname(L("con"))
#  	<< "," << conceptname(L("parent_con")) << "\n";
  if (L("con") == L("parent_con"))
    return 1; # true.
  L("con") = up(L("con"));
  }
return 0; # false.
}

########
# FUNC:	PNADDVALORIG
# SUBJ:	Add value to a node's variable.
# EX:	pnaddval(N(2),"hello",2,"newstr");
# NOTE:	For adding multiple values to a variable.
########
pnaddvalorig(
	L("node"),	# Node we are adding info to.
	L("field"),
	L("ord"),
	L("val")	# Taking zero also.
	)
{
if (!L("node") || !L("field"))
  return;
L("vals") = pnvar(L("node"),L("field"));
# Not checking on array length.

# Can't directly append a new value onto node.
# Need something like pnaddval(L("node"),L("field"),L("str")).
L("vals")[L("ord")] = L("val");
pnreplaceval(L("node"),L("field"),L("vals"));
}

########
# FUNC:	PNADDVAL	# MOVE.	# RENAME.	# 06/14/12 AM.
# SUBJ:	Add value to a node's variable.
# EX:	pnaddstr(N(2),"hello","newval");
# NOTE:	For adding multiple values to a variable.
#		MOVE. RENAME from pnaddstr().	# 06/14/12 AM.
# NLP++:	PROPER NLP++ FUNCTION FOR THIS SORELY LACKING.
########
pnaddval(
	L("node"),	# Node we are adding info to.
	L("field"),
	L("val")
	)
{
if (!L("node") || !L("field") || !L("val"))
  return;
L("vals") = pnvar(L("node"),L("field"));
if (!L("vals"))
  L("len") = 0;
else
  L("len") = arraylength(L("vals"));

# Can't directly append a new value onto node.
# Need something like pnaddval(L("node"),L("field"),L("str")).
L("vals")[L("len")] = L("val");
pnreplaceval(L("node"),L("field"),L("vals"));
}


########
# FUNC:	PNADDVALOPT	# RENAME.	# 06/14/12 AM.
# SUBJ:	Add value to a node's variable.
# EX:	pnaddval(N(2),"hello",2,"newstr");
# NOTE:	For adding multiple values to a variable.
#		RENAME from pnaddval()	# 06/14/12 AM.
########
pnaddvalopt(
	L("node"),	# Node we are adding info to.
	L("field"),
	L("ord"),
	L("val")	# Taking zero also.
	)
{
if (!L("node") || !L("field"))
  return;
L("vals") = pnvar(L("node"),L("field"));
# Not checking on array length.

# Can't directly append a new value onto node.
# Need something like pnaddval(L("node"),L("field"),L("str")).
L("vals")[L("ord")] = L("val");
pnreplaceval(L("node"),L("field"),L("vals"));
}


########
# FUNC:	LANGUAGEISO
# SUBJ:	Return ISO 639-1 code for a language name.
# EX:	
########

languageiso(L("str"))
{
if (!L("str"))
  return 0;
L("str") = strtoupper(L("str"));

if (L("str") == "ENGLISH")
  return "EN";
if (L("str") == "FRENCH")
  return "FR";
if (L("str") == "GERMAN")
  return "DE";
if (L("str") == "SPANISH")
  return "ES";
if (L("str") == "ITALIAN")
  return "IT";
if (L("str") == "PORTUGUESE")
  return "PT";
if (L("str") == "SWEDISH")
  return "SV";
if (L("str") == "DANISH")
  return "DA";
if (L("str") == "FINNISH")
  return "FI";
if (L("str") == "NORWEGIAN")
  return "NO";
if (L("str") == "INDONESIAN")
  return "ID";
if (L("str") == "DUTCH")
  return "NL";
return 0;
}


########
# FUNC:	LANGUAGEFMISO
# SUBJ:	Given ISO 639-1 code for a language name, return full name.
# EX:	
########

languagefmiso(L("str"))
{
if (!L("str"))
  return 0;
L("str") = strtoupper(L("str"));

if (L("str") == "EN")
  return "ENGLISH";
if (L("str") == "FR")
  return "FRENCH";
if (L("str") == "DE")
  return "GERMAN";
if (L("str") == "ES")
  return "SPANISH";
if (L("str") == "IT")
  return "ITALIAN";
if (L("str") == "PT")
  return "PORTUGUESE";
if (L("str") == "SV")
  return "SWEDISH";
if (L("str") == "DA")
  return "DANISH";
if (L("str") == "FI")
  return "FINNISH";
if (L("str") == "NO")
  return "NORWEGIAN";
if (L("str") == "ID")
  return "INDONESIAN";
if (L("str") == "NL")
  return "DUTCH";
return 0;
}


########
# FUNC:	STRTOKENIZE
# SUBJ:	Tokenize string into an array.
# RET:	Array, with each element holding a token.
# EX:	strtokenize("abc123"); => "abc" "123"
# OPT:	Brutally clunky and inefficient.
# TODO:	Implement as NLP++ internal function.
########

strtokenize(
	L("str")
	)
{
if (!L("str"))
  return 0;

L("len") = strlength(L("str")); # Yes, length of string.
L("arr") = 0;	# Array to build, one elt per token.
L("ii") = 0;	# Char offset in string.
L("jj") = 0;	# Array element being built.
L("tok") = 0;	# String being built for current token.
L("type") = 0;	# Token type being worked on.
	# a = alpha, n = num, 0 = punct, white, or none.
while (L("ii") < L("len"))
  {
  L("ch") = strpiece(L("str"),L("ii"),L("ii"));
  if (strisalpha(L("ch")) )
    {
	if (L("type") == "a")	# Continue alpha.
	  L("tok") = L("tok") + L("ch");
	else if (L("type") == "n")
	  {
	  L("arr")[L("jj")] = L("tok");	# Save number.
	  ++L("jj");
	  L("tok") = L("ch");
	  }
	else
	  L("tok") = L("ch");	# Start alpha.
	L("type") = "a";	# Working on alpha.
	}
  else if (strisdigit(L("ch")) )
    {
	if (L("type") == "n")	# Continue num.
	  L("tok") = L("tok") + L("ch");
	else if (L("type") == "a")
	  {
	  L("arr")[L("jj")] = L("tok");	# Save alpha.
	  ++L("jj");
	  L("tok") = L("ch");
	  }
	else
	  L("tok") = L("ch");	# Start num.
	L("type") = "n";	# Now working on num.
	}
  # NLP++: where is striswhite(), Amnon ?
  else if (L("ch") == " " || L("ch") == "\t"
  	|| L("ch") == "\n" || L("ch") == "\r")
	{
	if (L("type") == "a" || L("type") == "n")
	  {
	  L("arr")[L("jj")] = L("tok");	# Save token.
	  ++L("jj");
	  }
	# This function skips over whitespace.
	L("tok") = 0;
	L("type") = 0;
	}
  # NLP++: where is strispunct(), Amnon ?
  else	# Assume punct
    {
	if (L("type") == "a" || L("type") == "n")
	  {
	  L("arr")[L("jj")] = L("tok");	# Save token.
	  ++L("jj");
	  }
	# Save each punct char as single token.
	L("arr")[L("jj")] = L("ch");
	++L("jj");
	L("tok") = 0;
	L("type") = 0;
	}
  ++L("ii");	# Next offset in string.
  }

# Save the last token if need be.
if (L("type") == "a" || L("type") == "n")
  {
  L("arr")[L("jj")] = L("tok");	# Save token.
  ++L("jj");
  }

return L("arr");
}


########
# FUNC:	PNSTRPRETTY
# SUBJ:	Grab a node's text for pretty printing.
# EX:	
# NOTE:	Limit length of string grabbed.
#		Node may have a huge length (eg root of parse tree
#		node.  So limit to something like 50 chars, or this
#		becomes a big bottleneck for analyser speed.
########

pnstrpretty(
	L("n")	# Parse tree node.
	)
{
if (!L("n"))
  return 0;

L("MAX") = G("MAX");	# MAX STRING LENGTH TO GRAB.

# BOTTLENECK. CLAUSE LENGTH. May be huge.
L("s") = pnvar(L("n"),"$ostart");	# Start offset in input buffer.
L("e") = pnvar(L("n"),"$oend");		# End offset in input buffer.
if (L("e") - L("s") > L("MAX"))
	  {
	  L("e") = L("s") + L("MAX");
	  L("str") = inputrange(L("s"),L("e")) + " ...";
	  }
	else
	  L("str") = inputrange(L("s"),L("e"));
if (!L("str")) return L("str");
return strclean(L("str"));
#return L("str");
}


########
# FUNC:	PNSTRMAX
# SUBJ:	Grab a node's text, delimited length.
# EX:	
# NOTE:	Limit length of string grabbed.
#		Node may have a huge length (eg root of parse tree
#		node.  So limit to something like 50 chars, or this
#		becomes a big bottleneck for analyser speed.
# NOTE:	Uses original text from input buffer.
########

pnstrmax(
	L("n"),		# Parse tree node.
	L("MAX")	# Maximum size string to fetch.
	)
{
if (!L("n") || !L("MAX"))
  return 0;

# BOTTLENECK. CLAUSE LENGTH. May be huge.
L("s") = pnvar(L("n"),"$ostart");	# Start offset in input buffer.
L("e") = pnvar(L("n"),"$oend");		# End offset in input buffer.
if (L("e") - L("s") > L("MAX"))
  L("e") = L("s") + L("MAX");
L("str") = inputrange(L("s"),L("e"));
return L("str");
}


##############
## SETNODEVARCHAIN
## SUBJ: Set nodevar, chaining down.
## CR:	03/10/12 AM.
## RET:	
## TODO:	Add to NLP++ functions.
## EX:	setnodevarchain(N(2),"NOSP",N("NOSP",1));
##############

setnodevarchain(
	L("n"),	# Node to set.
	L("var"),	# Varname to set. can be 0.
	L("val")	# Value to set.
	)
{
if (!L("n") || !L("var")) return;	# Error...

while (L("n"))
  {
  pnreplaceval(L("n"),L("var"),L("val"));
  L("n") = pndown(L("n"));
  }
}


############################
# FN:	MIRROR
# CR:	(FOR TAI) 03/16/12 AM.
# RET:	FULL PATH FOR OUTPUT FILE.
# NOTE:	MODIFY TO RETURN OUTPUT FILE.
#	OUTPUT NAME BASED ON INPUT FILE HEAD.
#	Could specify as an argument to mirror() call.
#	# 03/18/12 AM. Split out mirrordir.
############################

mirror()
{
L("FULLDIR") = mirrordir("data",1);	# Create leaf folder.	# 03/18/12 AM.

# Now name and output file.
L("id") = G("$inputhead");	# OUTPUT NAMED USING NON-TAIL PART OF INPUT FILE.
L("fn") = L("FULLDIR") + "\\" + L("id") + ".txt";
#if (G("verbose")) "output.txt" << "final file=" << L("fn") << "\n";

# NLP++: May mangle newlines and other chars, use system call below.
# OPT:	System call below more efficient, better than inputrangetofile().
#L("s") = pnvar(pnroot(),"$ostart");
#L("e") = pnvar(pnroot(),"$oend");
#L("o") = openfile(L("fn"),0);	# OVERWRITE.
#inputrangetofile(L("s"),L("e"),L("o"));
#closefile(L("o"));
#L("o") = 0;

# COPY INPUT FILE TO MIRRORED OUTPUT PATH (plus DEV### folder).
#system("COPY /Y " + G("$input") + " " + L("fn"));
return L("fn");	# RETURN OUTPUT FILE PATH AND NAME TO CALLER.
}


############################
# FN:	MIRRORDIR
# CR:	(FOR TAI) 03/18/12 AM.
# RET:	FULL PATH FOR LAST DIRECTORY OF OUTPUT FILE.
# NOTE:	Split from MIRROR.
############################

mirrordir(
	L("outfolder"),		# "data" or "output"	# 02/28/14 AM.
	L("lastdirflag")	# 1 if create the leaf folder, else 0.	# 03/18/12 AM.
	)
{
if (!L("outfolder"))	# 02/28/14 AM.
  L("outfolder") = "output";	# RECOVER.	# 02/28/14 AM.

if (G("verbose")) "mirror.txt" << "IN MIRROR:" << "\n";

# Make a "root" output folder on disk.
L("FULLDIR") = G("$apppath") + "\\"
	+ L("outfolder")	# 02/28/14 AM.
	+ "\\FOLDERS";
mkdir(L("FULLDIR"));

# MAPPING OF INPUT FOLDERS TO OUTPUT FOLDERS.
L("arr") = G("ARR FOLDERS");
L("len") = G("ARR FOLDERS LEN");

#if (G("MODE") != "mirror")
#  {
#  # Or just exit or do something else, if you have other modes, etc.
#  "error.txt" << "MODE=" << G("MODE") << " not implemented." << "\n";
#  G("FAIL") = "MIRROR_MODE";
#  return;
#  }

# MIRROR INPUT FOLDERS.
# Traverse to find folder called "input" in array.
L("ii") = 0;
L("ii input") = 0;
L("done") = 0;
while (!L("done"))
  {
  L("dir") = L("arr")[L("ii")];
  L("lcdir") = strtolower(L("dir"));	# Lowercase.
  if (L("lcdir") == "input")
    {
	L("ii input") = L("ii");	# Found the folder called "input".
	++L("done");
	}
  ++L("ii");
  if (L("ii") >= L("len"))
    ++L("done");
  }

if (!L("ii input"))
  {
  "error.txt" << "Failed to find input folder in path." << "\n";
  G("FAIL") = "NO_INPUT_FOLDER";
  return;
  }

if (!L("ii input")+1 >= L("len"))
  {
  "error.txt" << "No folders under input folder. Unhandled" << "\n";
  G("FAIL") = "NO_INPUT_SUBFOLDER";
  return;
  }

# From below input folder to end of path, mirror the input folders.
# G("DIR") = Global that tracks full filename path for output.
# L("con") = Tracks the concept representing last folder in the path.
L("ii") = L("ii input") + 1;
while (L("ii") < L("len"))
  {
  L("dir") = L("arr")[L("ii")];
  L("FULLDIR") = L("FULLDIR") + "\\" + L("dir");
  # If making leaf folder, or not at leaf folder yet.	# 03/18/12 AM.
  if (L("lastdirflag") || (L("ii") < (L("len")-1) ))	# 03/18/12 AM.
    mkdir(L("FULLDIR"));
  ++L("ii");
  }

# Ok, we should be at bottom folder of input path.
#if (G("verbose")) "output.txt" << "gdir=" << L("FULLDIR") << "\n";

### MOVED STUFF FROM HERE TO mirror().	# 03/18/12 AM.

return L("FULLDIR");	# 03/18/12 AM.
}


##############
## PRETTYNODES
## SUBJ: Pretty print array of nodes.
## CR:	05/01/12 AM.
## RET:	
## NOTE:	A debugging aid.
## EX:	setnodevarchain(N(2),"NOSP",N("NOSP",1));
##############

prettynodes(L("arr"),L("o"))
{
if (!G("dev")) return;
if (!L("arr") || !L("o"))
  return;

L("o") << "\n" << "prettynodes:" << "\n";
L("len") = arraylength(L("arr"));
while (L("ii") < L("len"))
  {
  L("x") = L("arr")[L("ii")];
  L("o") << L("ii") << ": " << pnname(L("x"))
  	<< "\t" << nodetreetext(L("x")) << "\n";
  ++L("ii");
  }
}


########
# FUNC:	LOOKUPINTERNAL
# SUBJ:	Lookup a string in given hierarchy.
# CR:	05/04/12 AM.
# RET:	con = last con in phrase is found.
# EX:	L("con") = lookupinternal("PS3",G("phrases"));
########

lookupinternal(
	L("str"),
	L("croot")	# Root of "phrase tree" in kb.
	)
{
if (!L("str") || !L("croot"))
  return 0;

L("arr") = strtokenize(L("str"));
if (!L("arr"))
  return 0;

# Traverse down the phrase tree.
L("ii") = 0;
L("done") = 0;
L("con") = L("croot");
while (!L("done"))
  {
  L("txt") = L("arr")[L("ii")];
  if (L("txt"))
    L("con") = findconcept(L("con"),L("txt"));
  else if (L("con")
   && L("con") != L("croot") )	# 05/05/12 AM.
    return L("con");	# Found a concept.
  else
    return 0;

  if (!L("con")) return 0;
  ++L("ii");
  }
}



########
# FUNC:	STRTOPHRASE
# SUBJ:	Make/get a phrase by traversing down given kb hierarchy.
# CR:	05/09/12 AM.
# RET:	[0] last = last con in phrase.
#		[1] first = first concept in phrase.
# EX:	L("con") = makeemptyphrase("PS3",G("phrases"));
########

strtophrase(
	L("str"),
	L("croot")	# Root of "phrase tree" in kb.
	)
{
if (!L("str") || !L("croot"))
  return 0;

L("arr") = strtokenize(L("str"));
if (!L("arr"))
  return 0;

# Traverse down the phrase tree.
L("ii") = 0;
L("done") = 0;
L("con") = L("croot");
L("firstc") = 0;	# First concept created.	# 06/12/12 AM.
while (!L("done"))
  {
  L("txt") = L("arr")[L("ii")];
  if (L("txt"))
    {
	L("utxt") = strtoupper(L("txt"));
    L("con") = getconcept(L("con"),L("utxt"));
	if (!L("firstc")) L("firstc") = L("con");	# 06/12/12 AM.
	}
  else if (L("firstc"))	# 06/12/12 AM.
#  else if (L("con")
#   && L("con") != L("croot") )
    {
	L("a")[0] = L("con");	# leaf - last concept.	# 06/12/12 AM.
	L("a")[1] = L("firstc");	# First concept.	# 06/12/12 AM.
    return L("a");	# Found a concept. Return last/first.
	}
  else
    return 0;

  if (!L("con")) return 0;
  ++L("ii");
  }
return 0;	# 06/12/12 AM.
}


########
# FUNC:	STRTODEPUNCTPHRASE
# SUBJ:	Make/get a phrase by traversing down given kb hierarchy.
# CR:	05/09/12 AM.
# RET:	[0] last = last con in phrase.
#		[1] first = first concept in phrase.
# EX:	L("arr") = strtodepunctphrase("abc.def",G("phrases"),2);
########

strtodepunctphrase(
	L("str"),
	L("croot"),	# Root of "phrase tree" in kb.
	L("min")	# Min length to accept.
	)
{
if (!L("str") || !L("croot"))
  return 0;

L("x") = strdepunct(L("str"));
if (!L("x"))
  return 0;

L("arr") = strtokenize(L("x"));
if (!L("arr"))
  return 0;
L("len") = arraylength(L("arr"));
if (L("len") < L("min"))
  return 0;

# Traverse down the phrase tree.
L("ii") = 0;
L("done") = 0;
L("con") = L("croot");
L("firstc") = 0;	# First concept created.	# 06/12/12 AM.
while (!L("done"))
  {
  L("txt") = L("arr")[L("ii")];
  if (L("txt"))
    {
	L("utxt") = strtoupper(L("txt"));
    L("con") = getconcept(L("con"),L("utxt"));
	if (!L("firstc")) L("firstc") = L("con");	# 06/12/12 AM.
	}
  else if (L("firstc"))	# 06/12/12 AM.
#  else if (L("con")
#   && L("con") != L("croot") )
    {
	L("a")[0] = L("con");	# leaf - last concept.	# 06/12/12 AM.
	L("a")[1] = L("firstc");	# First concept.	# 06/12/12 AM.
    return L("a");	# Found a concept. Return last/first.
	}
  else
    return 0;

  if (!L("con")) return 0;
  ++L("ii");
  }
return 0;	# 06/12/12 AM.
}


########
# FUNC:	PRETTYSTRS
# SUBJ:	Pretty print an array of strings.
# CR:	06/22/12 AM.
########

prettystrs(
	L("arr"),
	L("ind"),	# Indent string.
	L("o")	# Output stream.
	)
{
if (!L("arr") || !L("o")) return;

L("len") = arraylength(L("arr"));
L("ii") = 0;
while (L("ii") < L("len"))
  {
  if (L("ind")) L("o") << L("ind");
  L("o") << "[" << L("ii") << "] ";
  L("o") << L("arr")[L("ii")] << "\n";
  ++L("ii");
  }
}


########
# FUNC:	PRETTYPNS
# SUBJ:	Pretty print an array of parse tree nodes.
# CR:	06/22/12 AM.
########

prettypns(
	L("arr"),
	L("ind"),	# Indent string.
	L("o")	# Output stream.
	)
{
if (!L("arr") || !L("o")) return;

L("len") = arraylength(L("arr"));
L("ii") = 0;
while (L("ii") < L("len"))
  {
  L("n") = L("arr")[L("ii")];
  if (L("ind")) L("o") << L("ind");
  L("o") << "[" << L("ii") << "] ";
  L("o") << pnname(L("n"))
   << "\t" << nodetreetext(L("n"))
   << "\n";
  ++L("ii");
  }
}


########
# FUNC:	ARRTOCOMMASTR
# SUBJ:	Convert an array to comma-separated string.
# CR:	06/26/12 AM.
########

arrtocommastr(
	L("arr")
	)
{
if (!L("arr")) return;

L("len") = arraylength(L("arr"));
L("ii") = 0;
L("str") = 0;
while (L("ii") < L("len"))
  {
  if (!L("str"))
    L("str") = L("arr")[L("ii")];
  else
    L("str") = L("str") + "," + L("arr")[L("ii")];
  ++L("ii");
  }
return L("str");
}


########
# FUNC:   PNFINDATTRDOWN
# SUBJ:   Find attr starting from current node.
# NOTE:	  Fetch the first one found.
#	Look at first nodes down the tree.
########

pnfindattrdown(L("n"),L("field"))
{
if (!L("n") || !L("field"))
  return 0;

# Look down.
while (L("n"))
  {
  if (L("x") = pnvar(L("n"),L("field")) )
    return L("x");
  L("n") = pndown(L("n"));
  }
return 0;
}


########
# FUNC:   PNRMVAL
# SUBJ:   Remove val from node's list.
# RET:	1 if found in list, else 0.
# NLP++:  Useful as a built-in (todo).
########

pnrmval(
	L("n"),		# Node with list.
	L("key"),	# Field or attr name.
	L("val")	# Attr value to remove.
	)
{
if (!L("n") || !L("key") || !L("val"))
  return 0;

L("list") = pnvar(L("n"),L("key"));
if (!L("list")) return 0;

L("ii") = 0;
L("flag") = 0;	# Flag if found.
L("lnew") = 0;	# New list.
while (L("x") = L("list")[L("ii")] )
  {
  if (L("x") != L("val"))
    {
	# Not the desired item. Add to new list.
	# OPT: N-squared, oould use a pnpush() NLP++ fun (todo).
	L("lnew") = addvalue(L("x"),L("lnew"));
	}
  ++L("ii");
  }

if (!L("flag")) return 0;

# Replace with modified list.
pnreplaceval(L("n"),L("key"),L("lnew"));

return 1;
}


########
# FUNC:   RMLISTVAL
# SUBJ:   Remove val from given list.
# RET:	1 if found in list, else 0.
# NLP++:  Useful as a built-in (todo).
########

rmlistval(
	L("list"),	# List.
	L("val")	# Attr value to remove.
	)
{
if (!L("list") || !L("val"))
  return 0;

L("ii") = 0;
L("flag") = 0;	# Flag if found.
L("lnew") = 0;	# New list.
while (L("x") = L("list")[L("ii")] )
  {
  if (L("x") != L("val"))
    {
	# Not the desired item. Add to new list.
	# OPT: N-squared, oould use a pnpush() NLP++ fun (todo).
	L("lnew") = addvalue(L("x"),L("lnew"));
	}
  ++L("ii");
  }

return L("lnew");
}


########
# FUNC:   RMLISTVALCASE
# SUBJ:   Remove str val from given list, case insensitive.
# RET:	1 if found in list, else 0.
# NLP++:  Useful as a built-in (todo).
########

rmlistvalcase(
	L("list"),	# List.
	L("val")	# Attr value to remove.
	)
{
if (!L("list") || !L("val"))
  return 0;

L("uval") = strtoupper(L("val"));
L("ii") = 0;
L("flag") = 0;	# Flag if found.
L("lnew") = 0;	# New list.
while (L("x") = L("list")[L("ii")] )
  {
  L("ux") = strtoupper(L("x"));
  if (L("ux") != L("uval"))
    {
	# Not the desired item. Add to new list.
	# OPT: N-squared, oould use a pnpush() NLP++ fun (todo).
	L("lnew") = addvalue(L("x"),L("lnew"));
	}
  ++L("ii");
  }

return L("lnew");
}


########
# FUNC:   FINDLASTNODE
# SUBJ:   Find last node in given list.
# RET:	1 if found in list, else 0.
# NLP++:  Useful as a built-in (todo).
# NOTE:	Like lasteltnode(), but that one requires rule element context.
#	last node in range. last range node lastrangenode.
########

findlastnode(
	L("n")
	)
{
if (!L("n"))
  return 0;
while (L("x") = pnnext(L("n")) )
  {
  L("n") = L("x");
  }
return L("n");
}

########################################################################

@CODE
L("hello") = 0;

if (!G("MAX")) G("MAX") = 256;	# LIMIT NODE TEXT.
G("LEN") = 0;	# LIMIT NODE TEXT.

@@CODE
