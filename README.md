# Description #
## NAIST ASR ##
This is a repository of NAIST ASR system for IWSLT 2015 ASR track.

We generated lattices of the following test set for
anyone who want to run experiments on the lattice.

### tst2013 ###
This is a test set for 2013 IWSLT ASR challenge, which consists of 28 TED
talks. The audio is manually segmented.

__Directory structure__:

* __graph_interpolate.pr1e7.arpa__: words and phoneme lists.
* __lats_4-gram_decoded__: lattices that generated using 4-gram language model.
* __lats_rnn_rescord__: lats_4-gram_decoded rescored with the interpolation of a 5-gram language model and RNNLM language model.
* __reference__: references.

## How to get WER ##
1. Install Kaldi
2. Make a soft link of __step__ and __utils__ folder from "WSJ" recipe inside Kaldi egs folder.
3. Change __KALDI_ROOT__ variable in __path.sh__ to installed Kaldi folder in step 1.
4. run:
```
./local/score.sh --cmd "run.pl" tst2013/reference tst2013/lats_4-gram_decoded
```

## How to get N-best ##
```
lattice-to-nbest --acoustic-scale=0.1 --n=10 "ark:gunzip -c tst2013/lats_4-gram_decoded/lat.1.gz|" ark,t:- | ./utils/int2sym.pl -f 3 tst2013/graph_interpolate.pr1e7.arpa/words.txt
```
See [Kaldi lattice format](http://kaldi.sourceforge.net/lattices.html) for more detail, especially graph and acoustic scores.

> It must be appreciated that graph and acoustic scores and input-label sequences are only valid when
> summed (or appended) over entire paths through the FST. There is no guarantee that they will be synchronized with respect to each other or with respect to the word labels.

> In general, the words in Kaldi lattices are not synchronized with to the transition-ids,
> meaning that the transition-ids on an arc won't necessarily all belong to the word whose label is on that arc.
> This means the times you get from the lattice will be inexact. It is also true of the weights. To obtain the exact times, you should run the program __lattice-align-words__.
> [Readmore](http://codingandlearning.blogspot.jp/2014/01/kaldi-lattices.html)

```
lattice-align-words tst2013/graph_interpolate.pr1e7.arpa/phones/word_boundary.int tst2013/model/final.mdl "ark:gunzip -c tst2013/lats_4-gram_decoded/lat.1.gz|" ark:- | lattice-to-nbest --acoustic-scale=0.1 --n=10 ark:- ark,t:- | ./utils/int2sym.pl -f 3 tst2013/graph_interpolate.pr1e7.arpa/words.txt
```

Another tool to [convert Kaldi lattice to HTK SLF format](https://gist.github.com/edobashira/5811963)

## Rescoring script ##
1. N-gram rescoring: steps/lmrescore.sh
2. RNNLM rescoring: steps/rnnlmrescore.sh


## LM training data ##
1. [TED.](https://github.com/truongdq/NAIST-ASR/blob/master/data/TED.txt)
2. WSJ.
3. [Europal v6.](http://www.statmt.org/europarl/v6/)
4. [Giga.](https://catalog.ldc.upenn.edu/LDC2003T05)
5. [News Commentary 08.](http://www.statmt.org/wmt12/translation-task.html )


## Citation ##
If you use this data for your research, please cite the following paper:
```
@inproceedings{heck2015iwslt,
  title={The {NAIST} English Speech Recognition System for {IWSLT} 2015},
  author={Heck, Michael and Truong, Do Quoc and Sakti, Sakriani and Neubig, Graham and Nakamura, Satoshi},
  booktitle={Proceedings of IWSLT},
  year={2015}
}

```
