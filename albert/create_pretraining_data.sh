#!/usr/bin/env bash

# Read data_text_dir path from a config file.
CURDIR=$(cd $(dirname $0); pwd)
source <(sed -n '/^\[DATA\]/,/^\[/p' ${CURDIR}/config.ini | grep TEXTDIR | sed 's/ *= */=/g')
source <(sed -n '/^\[SENTENCEPIECE\]/,/^\[/p' ${CURDIR}/config.ini | grep PREFIX | sed 's/ *= */=/g')

echo ${PREFIX}

for DIR in $( find ${TEXTDIR} -mindepth 1 -type d ); do
  python3 -m albert.create_pretraining_data \
    --input_file=${DIR}/all.txt \
    --output_file=${DIR}/all-maxseq512.tfrecord \
    --spm_model_file=${PREFIX}.model \
    --vocab_file=${PREFIX}.vocab \
    --do_lower_case=False \
    --max_seq_length=512 \
    --max_predictions_per_seq=20 \
    --masked_lm_prob=0.15 \
    --random_seed=12345 \
    --dupe_factor=5 \
    --do_whole_word_mask=True
done