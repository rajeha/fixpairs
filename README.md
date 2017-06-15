Fixes read pairs in two fastq files.

__Example:__
```
$ wc -l read1.fq read2.fq
  2400 read1.tmp
  2416 read2.tmp
  4816 total
```
```
$ head -1 read1.fq read2.fq
==> read1.fq <==
@SRR1297048.2054293/1

==> read2.fq <==
@SRR1297048.2492141/2
```
read1.fq and read2.fq seem to be out of sync. Let's fix them:
```
$ fix_pairs.pl read1.fq read2.fq fixed
```
Quick check:
```
$ wc -l fixed1.fq fixed2.fq fixed_unpaired.fq
  2268 fixed1.fq
  2268 fixed2.fq
   280 fixed_unpaired.fq
  4816 total
```
```
$ head -1 fixed1.fq fixed2.fq
==> fixed1.fq <==
@SRR1297048.3347589/1

==> fixed2.fq <==
@SRR1297048.3347589/2
```



