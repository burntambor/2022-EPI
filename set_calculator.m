function [result,meanResult,megaset] = set_calculator(setID,memberID,results,indicators,countryAttributes)
%% data setup
%results = readtable('2022-epi.xlsx','Sheet','3_EPI_Results','TreatAsMissing','NA');
%indicators = readtable('2022-epi.xlsx','Sheet','6_EPI_Weights');
%countryAttributes = readtable('2022-epi.xlsx','Sheet','7_EPI_Country_Attributes');

%reorganize abbreviations to match the order they come in in the results
order = indicators.Order;
startAbbs = indicators.Abbreviation;
[~,iOrder] = sort(order);
abbs = categorical(startAbbs(iOrder,:));

%structure world (setID 1) so it is easy to use in app like setIDs 2-5
world = cell(height(results),3);
[x,y] = unique(results.country); %setID = 1
for k = 1:height(results)
    world{k,1} = 'World'; %category
    world{k,2} = y(k); %inds
    world{k,3} = x{k}; %country names
end
continents = unique(countryAttributes.continent); %setID = 2
regions = unique(countryAttributes.region); %setID = 3
unsdRegions = unique(countryAttributes.unsd_region); %setID = 4
%setID = 5
groups = table2cell(readtable('2022-epi.xlsx','Sheet','7_EPI_Country_Attributes','ReadVariableNames',0,'Range','N1:AB1'))';

numAbbs = height(abbs);

%% create cells for easy indexing use in app that will go into megaset
for n = 1:length(continents)
    %find inds of countries that are a member of nth continent 
    ind = strcmp(countryAttributes.continent,continents{n});
    %save these country names using the inds
    indCountry = countryAttributes.country(ind);
    %store the inds to continents{n,2} and the country names to continents{n,3}
    [continents{n,3},~,continents{n,2}] = intersect(indCountry,results.country);
end

%repeat same process as for continents
for nn = 1:length(regions)
    ind = strcmp(countryAttributes.region,regions{nn});
    full = countryAttributes.country(ind);
    [regions{nn,3},~,regions{nn,2}] = intersect(full,results.country);
end

%repeat same process as for continents
for nnn = 1:length(unsdRegions)
    ind = strcmp(countryAttributes.unsd_region,unsdRegions{nnn});
    full = countryAttributes.country(ind);
    [unsdRegions{nnn,3},~,unsdRegions{nnn,2}] = intersect(full,results.country);
end

%group data is logical rather than strings so needs new approach
startColumn = 14; %starting column of where logical data is provided is 14
for nnnn = startColumn:startColumn+length(groups)-1
    %find countries that have a 1 for nnnnth group
    ind = find(countryAttributes{:,nnnn} == 1);
    %save these country names using the inds
    full = countryAttributes.country(ind);
     %store the inds of countries to groups{n,2} and the country names to groups{n,3}
    [groups{nnnn-startColumn+1,3},~,groups{nnnn-startColumn+1,2}] = ...
        intersect(full,results.country);
end

%% megaset

%create megaset of set cells for easy indexing use in app
megaset = {world;continents;regions;unsdRegions;groups};

%% result
%create set matrices where rows corresponds to member and cols is the var
startCol = 4;

if setID == 1
    numCountries = height(world); %take height of countries
    scoresWorld = nan(numCountries,numAbbs);
    for i = 1:numCountries %for each country
        for j = 1:numAbbs
             %store each var in that country's row as cols
            scoresWorld(i,j) = results{i,j+startCol};
        end
    end
    %output country's 55 var data by indexing using memberID
    result = scoresWorld(memberID,:);
end
    
if setID == 2
    %for given continent of set, store how many countries it contains
    numCountries = height(continents{memberID,2});
    scoresContinent = nan(numCountries,numAbbs);
    continentInds = continents{memberID,2};
    for i = 1:numCountries %for each country in the continent
        for j = 1:numAbbs
             %store each var in that country's row as cols
            scoresContinent(i,j) = results{continentInds(i),j+startCol};
        end
    end
    %the chosen continent's overall data is averaged
    %from all its countries' data
    result = mean(scoresContinent,1,'omitnan');
end

%same as continents but for regions
if setID == 3
    numCountries = height(regions{memberID,2});
    scoresRegion = nan(numCountries,numAbbs);
    regionInds = regions{memberID,2};
    for i = 1:numCountries
        for j = 1:numAbbs
            scoresRegion(i,j) = results{regionInds(i),j+startCol};
        end
    end
    result = mean(scoresRegion,1,'omitnan');
end

%same as continents but for UNSD regions
if setID == 4
    numCountries = height(unsdRegions{memberID,2});
    scoresUnsd = nan(numCountries,numAbbs);
    unsdInds = unsdRegions{memberID,2};
    for i = 1:numCountries
        for j = 1:numAbbs
            scoresUnsd(i,j) = results{unsdInds(i),j+startCol};
        end
    end
    result = mean(scoresUnsd,1,'omitnan');
end

%same as continents but for groups
if setID == 5
    numCountries = height(groups{memberID,2});
    scoresGroup = nan(numCountries,numAbbs);
    groupInds = groups{memberID,2};
    for i = 1:numCountries
        for j = 1:numAbbs
            scoresGroup(i,j) = results{groupInds(i),j+startCol};
        end
    end
    result = mean(scoresGroup,1,'omitnan');
end

%% mean results

%copied from setID = 1 above
numCountries = height(world); %take height of countries
scoresWorld = nan(numCountries,numAbbs);
for i = 1:numCountries %for each country
    for j = 1:numAbbs
         %store each var in that country's row as cols
        scoresWorld(i,j) = results{i,j+startCol};
    end
end

%mean world result can be taken by averaging the whole scoresWorld data
meanResult = mean(scoresWorld,1,'omitnan');