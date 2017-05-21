function [nn_input,nn_input_compare,nn_output,nn_output_compare] = NN_Setup_OneNode_Directions_FUN(force_node_compare,node_choice,dir)

load_data = 1;

if load_data

        
load('/Users/MicTonutti/Dropbox/MRes/Individual Project/Modelling_New/Mesh_Variables.mat');
cmbrain = centerOfMass(main_brain.img);

load('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node101/Variables1.mat','DATA_coord','nodes_list');

force_nodes = [82;91;101;107;129;140;148;163;174;185;203];
%force_node_compare = 203;
force_nodes = force_nodes(force_nodes(:,1)~=force_node_compare,1);
fn = 20;
nn_input = NaN;
nn_output = NaN;
%node_choice = 10;
a=1;
err = [];

for i = 1:size(force_nodes,1)
    force_node = force_nodes(i);
    dir_name = strcat('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node',num2str(force_node));
    var_filename = strcat(dir_name,'/All_Nodes_Iterations_Fn',num2str(force_node),'.mat');
    load(var_filename);
    for z = 1:30
        for n = node_choice
            for f = 1:fn
                %if iterations{z}.cos_plot(n,f)>0
                for g =1:3
                    nn_input(a,g) = iterations{z}.force_direction(f,g);
                end
                nn_input(a,4) = iterations{1}.dist_plot(n,f);
                
                for h=1:3
                    th(h) = iterations{z}.force_direction(fn,h)/norm(iterations{z}.force_direction(fn,:));
                    th(h) = acos(th(h));
                    nn_input(a,4+h) = th(h);
                end
                
                for xyz = 1:3
                    vectemp(1,xyz) = DATA_coord(force_node,xyz+1,1);
                    vectemp(2,xyz) = cmbrain(xyz);
                end
                nn_input(a,8) = pdist(vectemp);
                
                r = vrrotvec(DATA_coord(force_node,2:4,1)-DATA_coord(nodes_list(node_choice),2:4,1),iterations{z}.force_direction(fn,:));
                nn_input(a,9) = r(1);
                nn_input(a,10) = r(2);
                nn_input(a,11) = r(3);
                nn_input(a,12) = r(4);
                
                %nn_output(a,1) = iterations{z}.displ_tot_plot(n,f);
               for gg = dir
                tho = iterations{z}.displ_max_vector{n,f}(gg)/norm(iterations{z}.displ_max_vector{n,f}(:));
                tho = acos(tho);
                
                nn_output(a,1) = tho;
            end
                
                
                a=a+1;
                %end
            end
        end
    end
    a
end


nn_input_compare = NaN;
nn_output_compare = NaN;
a=1;
z=1;
dir_name = strcat('/Volumes/Macintosh HD/Users/MicTonutti/Documents/Imperial/MRes/Individual Project 2/Nodewise Simulations/Node',num2str(force_node_compare));

var_filename = strcat(dir_name,'/All_Nodes_Iterations_Fn',num2str(force_node_compare),'.mat');
load(var_filename);
for z = 1:30
for n = node_choice
    for f = 1:fn
        %if iterations{z}.cos_plot(n,f)>0
             %nn_input_compare(a,1) = iterations{z}.cos_plot(n,f);
            for g =1:3
            nn_input_compare(a,g) = iterations{z}.force_direction(f,g);
            end
            nn_input_compare(a,4) = iterations{1}.dist_plot(n,f);
            
            for h=1:3
            th(h) = iterations{z}.force_direction(fn,h)/norm(iterations{z}.force_direction(fn,:));
            th(h) = acos(th(h));
            nn_input_compare(a,4+h) = th(h);          
            end
            
            for xyz = 1:3
                vectemp(1,xyz) = DATA_coord(force_node_compare,xyz+1,1);
                vectemp(2,xyz) = cmbrain(xyz);
            end
            nn_input_compare(a,8) = pdist(vectemp);
            %nn_output_compare(a,1) = iterations{z}.displ_tot_plot(n,f);
            
            r = vrrotvec(DATA_coord(force_node_compare,2:4,1)-DATA_coord(nodes_list(node_choice),2:4,1),iterations{z}.force_direction(fn,:));
            nn_input_compare(a,9) = r(1);
            nn_input_compare(a,10) = r(2);
            nn_input_compare(a,11) = r(3);
            nn_input_compare(a,12) = r(4);
            
            for gg = dir
                tho = iterations{z}.displ_max_vector{n,f}(gg)/norm(iterations{z}.displ_max_vector{n,f}(:));
                tho = acos(tho);
                
                nn_output_compare(a,1) = tho;
            end
            
            a=a+1;
        %end
    end
end
end
end

end

% nn=0;
% if nn
% Y = myNeuralNetworkFunction_OneNode(nn_input_compare);
% aaaa = abs(nn_output_compare-Y)./nn_output_compare*100;
% avger = mean(aaaa)
% 
% end
