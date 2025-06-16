function ax = geomap4final(megasetWithSetID,memberID)

%plot and save object from bordersm function
bordersm;
hold on

%take and store input cell
set = megasetWithSetID;

%the country names from the spreadsheet do not all match up to the
%bordersm names. these are the cases don't match and need to be fixed.
%i have to put the inputs through this correction process otherwise
%the map component will not be completely accurate

%if member of input cell is also a cell, i.e. a set:
if iscell(set{memberID,3})
    %store that set
    member = set{memberID,3};
    %need for loop to go through each member of the set and correct names
    for i = 1:length(member)
        if strncmp(member{i},'Cabo Verde',100)
            member{i} = 'Cape Verde';
        elseif strncmp(member{i},'Dem. Rep. Congo',100)
            member{i} = 'Democratic Republic of the Congo';
        elseif strncmp(member{i},'Eswatini',100)
            member{i} = 'Swaziland';
        elseif strncmp(member{i},'Iran',100)
            member{i} = 'Iran Islamic Republic of';
        elseif strncmp(member{i},'Laos',100)
            member{i} = 'Lao People''s Democratic Republic';
        elseif strncmp(member{i},'Micronesia',100)
            member{i} = 'Micronesia, Federated States of';
        elseif strncmp(member{i},'Moldova',100)
            member{i} = 'Republic of Moldova';
        elseif strncmp(member{i},'Myanmar',100)
            sprintf('For some reason, Myanmar is not included in this function')
        elseif strncmp(member{i},'North Macedonia',100)
            member{i} = 'The former Yugoslav Republic of Macedonia';
        elseif strncmp(member{i},'Republic of Congo',100)
            member{i} = 'Congo';
        elseif strncmp(member{i},'South Korea',100)
            member{i} = 'Korea, Republic of';
        elseif strncmp(member{i},'Tanzania',100)
            member{i} = 'United Republic of Tanzania';
        elseif strncmp(member{i},'United States of America',100)
            member{i} = 'United States';
        end

        %plot each perhaps-corrected member because bordersm can only
        %take one name at a time
        bordersm(member{i},'facecolor','red');
        hold on
    end
%if just one country, don't need a for loop to do this
elseif ~iscell(set{memberID,3})
    member = set{memberID,3};
    if strncmp(member,'Cabo Verde',100)
        member = 'Cape Verde';
    elseif strncmp(member,'Dem. Rep. Congo',100)
        member = 'Democratic Republic of the Congo';
    elseif strncmp(member,'Eswatini',100)
        member = 'Swaziland';
    elseif strncmp(member,'Iran',100)
        member = 'Iran Islamic Republic of';
    elseif strncmp(member,'Laos',100)
        member = 'Lao People''s Democratic Republic';
    elseif strncmp(member,'Micronesia',100)
        member = 'Micronesia, Federated States of';
    elseif strncmp(member,'Moldova',100)
        member = 'Republic of Moldova';
    elseif strncmp(member,'Myanmar',100)
        sprintf('For some reason, Myanmar is not included in this function')
    elseif strncmp(member,'North Macedonia',100)
        member = 'The former Yugoslav Republic of Macedonia';
    elseif strncmp(member,'Republic of Congo',100)
        member = 'Congo';
    elseif strncmp(member,'South Korea',100)
        member = 'Korea, Republic of';
    elseif strncmp(member,'Tanzania',100)
        member = 'United Republic of Tanzania';
    elseif strncmp(member,'United States of America',100)
        member = 'United States';
    end
    
    %plot with perhaps-corrected name
    bordersm(member,'facecolor','red');
end
axis off
ax = gca();