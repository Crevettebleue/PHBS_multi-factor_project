function [X, offsetSize] = HSIGMA(stock)
% computed as the volatility of residual returns in beta
% the benchmark is zz500
% the volatility is estimated over the trailing 252 trading days of returns
% with a hali-lif of 63 trading days.
% stock is a structure

% clean data module here

% get factor module here
    [X,offsetSize] = getAlpha(stock.properties.totalReturn;
                              stock.index.totalReturn[:,7]);
end

%-------------------------------------------------------------------------
function [exposure offsetSize] = getAlpha(stockrts,ZZ500rts)
    [m,n]= size(stockrts);
	w = ExponentialWeight(252, 63);
    wMatrix =  repmat(w,1,n); 
    
    for i = 252:m
        wStockRts = stockrts(i-251:i,:) .* wMatrix;
        wZZ500Rts = ZZ500rts(i-251:i,:) .* w;
        toCell =mat2cell(wStockRts,252,[ones(1,n)]);
        B =blkdiag(toCell{:});%diag each column of the wStockRts  
        
        Y = repmat(wZZ500Rts,n,1);
        beta(i,:) = (B'*B\(B' * Y ))';
        
        res = Y - B * beta(i,:)';
        reRes = reshape(res,252,6);
        exposure(i,:) = std(reRes);
    end
        offsetSize = 521;
end
