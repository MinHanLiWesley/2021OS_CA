#! /bin/zsh
INPUT_ARG_FILE="input_arg_tmp.txt"
ASM_RESULT_FILE="asm_code_result.txt"
for(( i = 0 ; i <= 1024 ; i += 1 ))
do
	echo ${i} > ${INPUT_ARG_FILE}
	jupiter -b b06501050_hw3.s < ${INPUT_ARG_FILE} | head -1 >> ${ASM_RESULT_FILE} 
done

rm ${INPUT_ARG_FILE}
