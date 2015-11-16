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

## Rescoring script ##
1. N-gram rescoring: steps/lmrescore.sh
2. RNNLM rescoring: steps/rnnlmrescore.sh


## LM training data ##
1. WSJ.
2. [Europal v6.](http://www.statmt.org/europarl/v6/)
3. [Giga.](https://catalog.ldc.upenn.edu/LDC2003T05)
4. News Commentary 08.
5. [TED.](https://github.com/truongdq/NAIST-ASR/blob/master/data/TED.txt)


## Citation ##
If you use this data for your research, please cite the following paper:
```
@inproceedings{heck2015iwslt,
  title={The {NAIST} English Speech Recognition System for {IWSLT} 2015},
  author={Heck, M. and Truong, D.Q. and Sakti, S. and Neubig, G. and Nakamura, S.},
  booktitle={Proceedings of IWSLT},
  year={2015}
}

```
