Albedo_PP =ELM_notop_Albedo_weighted_all;
Albedo_3D = ELM_top_Albedo_weighted_all;


figure;
subplot(1,2,1)
hold on;
plot(Albedo_PP, 'r')
plot(Albedo_3D,'b')
plot(Albedo_3D - Albedo_PP,'g')
legend('PP','TOP','TOP-3D')
subplot(1,2,2)
hold on;
plot(ELM_notop_FSA_all, 'r')
plot(ELM_top_FSA_all,'b')
plot(ELM_top_FSA_all - ELM_notop_FSA_all,'g')