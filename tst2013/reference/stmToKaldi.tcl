encoding system utf-8

#===============================================================================
# Generates a Kaldi db, given a corpus.
#
# Author:
# Michael Heck
#===============================================================================

#-------------------------------------------------------------------------------
# Command Line Arguments:
#-------------------------------------------------------------------------------
set stmFile   "/project/nakamura-lab01/Share/Project/IWSLT2015/data/test/tst2013.en/tst2013.en.stm"
set audioPath "/project/nakamura-lab01/Share/Project/IWSLT2015/data/test/tst2013.en/audio"

if [catch {itfParseArgv $argv0 $argv [list [
    list -stmFile		string     {}   stmFile               {}   {Input STM file.}      ] [
    list -audioPath             string     {}   audioPath             {}   {Path to audio files.} ] ]
} ] {
    puts stderr "ERROR in $argv0 while scanning options"
    exit -1
}

array set wavArr  {}
array set u2sArr  {}
array set s2uArr  {}
array set txtArr  {}
array set fromArr {}
array set toArr   {}


# Reading the STM file.
# Example: tst2013.talkid1518 1 tst2013.talkid1518 170.54 172.14 <O,F0,UNKNOWN> Who sends whom a text message
set FI(STM) [open $stmFile r]
fconfigure $FI(STM) -encoding utf-8

set prevId ""
while { [gets $FI(STM) line] >= 0 } {
    if { [regexp "^;;" $line] } {
	continue
    }
    
    set convId [lindex $line 0]
    set from   [lindex $line 3]
    set to     [lindex $line 4]
    set text   [lrange $line 6 end]

    if { $prevId != $convId } {
	set uttItr 0
	set prevId $convId
    }
    
    set uttId ${convId}_[format "%-03d" ${uttItr}]
    #set uttId ${convId}_${from}_${to}
    #regsub -all {\.} $uttId "_" uttId

    set txtArr($uttId)  $text
    set u2sArr($uttId)  $convId
    set fromArr($uttId) $from
    set toArr($uttId)   $to

    set wavArr($convId)  ${audioPath}/${convId}.sph
    
    lappend s2uArr($convId) $uttId 

    incr uttItr
    
    # Check if file actually exists.
    if { ![file exists ${audioPath}/${convId}.sph] } {
        putsWarn "Audio file '${audioPath}/${convId}.sph' does not exist!"
    }
}

close $FI(STM)

set FO(SEG) [open "segments" w]
fconfigure $FO(SEG) -encoding utf-8

set FO(U2S) [open "utt2spk" w]
fconfigure $FO(U2S) -encoding utf-8

set FO(S2U) [open "spk2utt" w]
fconfigure $FO(S2U) -encoding utf-8

set FO(TXT) [open "text" w]
fconfigure $FO(TXT) -encoding utf-8

set FO(WAV) [open "wav.scp" w]
fconfigure $FO(WAV) -encoding utf-8

set FO(R2F) [open "reco2file_and_channel" w]
fconfigure $FO(R2F) -encoding utf-8

foreach uttId [lsort -dictionary [array names txtArr]] {
    puts $FO(SEG) "$uttId $u2sArr($uttId) $fromArr($uttId) $toArr($uttId)"

    puts $FO(U2S) "$uttId $u2sArr($uttId)"

    puts $FO(TXT) "$uttId $txtArr($uttId)"

    puts $FO(R2F) "$u2sArr($uttId) $u2sArr($uttId) 1"
}

# spkId and convId are identical here.
foreach spkId [lsort -dictionary [array names s2uArr]] {
    puts $FO(S2U) "$spkId $s2uArr($spkId)"

    #puts $FO(WAV) "$spkId $wavArr($spkId)"
    puts $FO(WAV) "$spkId /project/nakamura-lab01/Share/Tools/kaldi/kaldi-garaxy/tools/sph2pipe_v2.5/sph2pipe -f wav $wavArr($spkId) |"
}


close $FO(R2F)
close $FO(WAV)
close $FO(TXT)
close $FO(S2U)
close $FO(U2S)
close $FO(SEG)

exit
